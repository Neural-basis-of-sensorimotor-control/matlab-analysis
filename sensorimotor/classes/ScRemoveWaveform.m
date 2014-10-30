classdef ScRemoveWaveform < ScTrigger
    properties
        parent
        original_stimpos
        stimpos
        stimpos_offsets
        width
        tag
        v_median
        v_interpolated_median
        tstart
        tstop
    end
    methods
        
        function obj = ScRemoveWaveform(waveform)
            obj.initialize(waveform);
        end
        
        %Assuming that tmin = 0 for conversion from time to discrete time
        %steps
        function calibrate(obj,v)
            obj.stimpos = obj.original_stimpos;
            ranges = bsxfun(@plus,obj.stimpos,round([-obj.width/5 obj.width/5]));
            ranges(ranges<1) = 1*ones(size(find(ranges<1)));
            ranges(ranges>numel(v)-(obj.width+1)) = (numel(v)-(obj.width+1))*ones(size(find(ranges>numel(v)-(obj.width+1))));
            overlap = ranges(1:end-1,2)>=ranges(2:end,1);
            ranges(overlap,2) = floor((obj.stimpos([overlap; false])+obj.stimpos([false; overlap]))/2);
            ranges([false; overlap],1) = ranges([overlap; false],2)+1;
            
            max_nbr_of_iterations = 5;
            it = 1;
            prev_stimpos = [];
            while it<=max_nbr_of_iterations && (it==1 || ~nnz(prev_stimpos - obj.stimpos))
                [~,obj.v_median] = sc_remove_artifacts(v,obj.width,obj.stimpos);
                prev_stimpos = obj.stimpos;
                for i=1:numel(obj.stimpos)
                    obj.stimpos(i) = obj.find_min(ranges(i,:),v);
                end
                it = it+1;
            end
            if it>max_nbr_of_iterations
                fprintf('Warning: Reached maximum number of iterations (=%i) in %s\n',max_nbr_of_iterations,mfilename);
            end
            obj.stimpos_offsets = zeros(size(obj.stimpos));
            [~,obj.v_interpolated_median] = sc_remove_artifacts(v,obj.width+2,obj.stimpos-1);
            t_index = (0:(obj.width+1))';
            times = t_index*obj.parent.dt;
            sp = spaps(times,obj.v_interpolated_median,1e-6);
            obj.v_interpolated_median = fnval(sp,times);
            
            it=1;
            max_nbr_of_iterations = 3;
            %todo: add check for convergence
            while it<=max_nbr_of_iterations
                for k=1:numel(obj.stimpos)
                    s = v(obj.stimpos(k)+t_index) - v(obj.stimpos(k));
                    ind = (2:obj.width+1)';
                    Y = obj.v_interpolated_median(ind) - s(ind);
                    X = .5*(s(ind-1) - obj.v_interpolated_median(ind+1));
                    obj.stimpos_offsets(k) = X\Y + 2;
                end
                below_bounds = obj.stimpos_offsets < -1;
                above_bounds = obj.stimpos_offsets > 1;
                obj.stimpos_offsets(below_bounds | above_bounds) = zeros(size(find(below_bounds | above_bounds)));
                obj.stimpos_offsets = obj.parent.dt*obj.stimpos_offsets;
                new_v_median = nan(obj.width,numel(obj.stimpos));
                
                pp = spaps(times,obj.v_interpolated_median,1e-6);
                for k=1:numel(obj.stimpos)
                    new_v_median(:,k) = fnval(pp,times(2:end-1)+obj.stimpos_offsets(k));
                end
                obj.v_interpolated_median(2:end-1) = mean(new_v_median,2);
                dbgplt(17+it,[],obj.v_interpolated_median);
                it = it+1;
            end
        end
        
        function v=remove_wf(obj,v,tmin)
            if isempty(obj.v_interpolated_median)
                msgbox(sprintf('You will need to calibrate ScRemoveWaveform %s',obj.tag));
                return
            end
            removepos = obj.stimpos-round(tmin/obj.parent.dt);
            removepos(removepos<2) = 2*ones(size(find(removepos<1)));
            removepos(removepos>=numel(v)) = (numel(v)-1)*ones(size(find(removepos>=numel(v))));
            tail_length = min(ceil(obj.width/3),20);
            last_f_val =1e-3;
            c = obj.width - tail_length;
            a = log(1/last_f_val-1)/(c-obj.width);
            f = sigmf((1:obj.width)',[a c]);
            times = (0:(obj.width+1))'*obj.parent.dt;
            pp = spaps(times,obj.v_interpolated_median,1e-6);
            for k=1:numel(removepos)
                pos = removepos(k) + (0:obj.width-1)';
                v(pos) = v(pos) - f.*fnval(pp,times(2:end-1)+obj.stimpos_offsets(k));%f.*obj.v_interpolated_median(2:end-1)';%
            end
        end
        
        function update_waveform(obj,v)
            list = obj.parent.waveforms;
            wf_tag = obj.tag(2:end);
            if ~sc_contains(list.values('tag'),wf_tag)
                msgbox(sprintf('Cannot update waveform: %s. No waveform with this name.',wf_tag));
            else
                waveform = list.get('tag',wf_tag);
                obj.initialize(waveform);
                obj.calibrate(v);
            end
        end
        
        function times = gettimes(obj,tmin,tmax)
            times = obj.stimpos*obj.parent.dt;
            times = times(times>=tmin & times<tmax);
        end
    end
    methods (Access = 'protected')
        function minpos = find_min(obj,minmax,v)
            ressqrd = nan(sc_range(minmax)+1,1);
            indices = minmax(1):minmax(2);
            for j=1:numel(indices)
                residual = v(indices(j): (indices(j)+obj.width-1) )' - v(indices(j)) - obj.v_median;
                ressqrd(j) = sum(residual.^2);
            end
            [~,ind] = min(ressqrd);
            minpos = indices(ind);
        end
        %         function ressqrd = find_offset(obj,v, stimpos, stimpos_offset)
        %             t = (0:(obj.width+1))';
        %             ressqrd = double(sqrt( sum( ( v(stimpos+t(1:end-2)) - v(stimpos) - interp1(t,obj.v_interpolated_median,t(2:end-1)+stimpos_offset) ).^2 ) ));
        %         end
        function initialize(obj,waveform)
            obj.parent = waveform.parent;
            obj.tag = ['#' waveform.tag];
            obj.width = waveform.width;
            obj.original_stimpos = round(waveform.gettimes(0,inf)/waveform.parent.dt)+1;
            obj.stimpos = obj.original_stimpos;
            below_one = find(obj.stimpos<1);
            above_max = find(obj.stimpos>waveform.parent.N);
            obj.stimpos(below_one) = ones(size(below_one));
            obj.stimpos(above_max) = waveform.parent.N*ones(size(above_max));
        end
    end
end