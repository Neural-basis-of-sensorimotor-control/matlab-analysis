classdef ScRemoveWaveform < handle
    properties
        parent
        stimpos
        width
        tag
        v_median
    end
    methods
        %Assuming that tmin = 0 for conversion from time to discrete time
        %steps
        function obj = ScRemoveWaveform(waveform)
            obj.parent = waveform.parent;
            obj.tag = waveform.tag;
            obj.width = waveform.width;
            obj.stimpos = round(waveform.gettimes(0,inf)/waveform.parent.dt)+1;
            below_one = find(obj.stimpos<1);
            above_max = find(obj.stimpos>waveform.parent.N);
            obj.stimpos(below_one) = ones(size(below_one));
            obj.stimpos(above_max) = waveform.parent.N*ones(size(above_max));
        end
        
        function calibrate(obj,v)
            ranges = bsxfun(@plus,obj.stimpos,round([-obj.width/10 obj.width/10]));
            ranges(ranges<1) = 1*ones(size(find(ranges<1)));
            ranges(ranges>numel(v)-numel(obj.v_median)) = (numel(v)-numel(obj.v_median))*ones(size(find(ranges>numel(v)-numel(obj.v_median))));
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
        end
        
        function v=remove_wf(obj,v,tmin)
            removepos = obj.stimpos-round(tmin/obj.parent.dt);
            removepos(removepos<1) = ones(size(find(removepos<1)));
            v = sc_remove_artifacts(v,obj.width,removepos);
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
    end
end