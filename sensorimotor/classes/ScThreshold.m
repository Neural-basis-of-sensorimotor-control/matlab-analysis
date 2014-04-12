classdef ScThreshold < handle
    properties

        position_offset
        v_offset
        lower_tolerance
        upper_tolerance
        
        max_matrix_size = 1e7   %can be changed to optimize speed and memory
                                %usage, optimal value depends on available
                                %RAM
    end
    
    properties (Dependent)
        n
        width
    end
    
    methods
        function obj = ScThreshold(position_offset, v_offset, lower_tolerance, upper_tolerance)
            obj.position_offset = position_offset;
            obj.v_offset = v_offset;%(ind);
            obj.lower_tolerance = lower_tolerance;%(ind);
            obj.upper_tolerance = upper_tolerance;%(ind);
            %Set highest abs v offset first, then highest deviation from
            %previous value as second
            [~,dim] = max(size(obj.v_offset));
            [~,ind] = sort(abs(obj.v_offset),dim,'descend');
            obj.v_offset = obj.v_offset(ind);
            obj.position_offset = obj.position_offset(ind);
            obj.lower_tolerance = obj.lower_tolerance(ind);
            obj.upper_tolerance = obj.upper_tolerance(ind);
            [~,ind] = sort(abs(obj.v_offset(1)-obj.v_offset(2:end)),dim,'descend');
            obj.v_offset(2:end) = obj.v_offset(ind+1);
            obj.position_offset(2:end) = obj.position_offset(ind+1);
            obj.lower_tolerance(2:end) = obj.lower_tolerance(ind+1);
            obj.upper_tolerance(2:end) = obj.upper_tolerance(ind+1);
        end

        %see ScWaveform for explanation
        function [spikepos, wfarea] = match_handle(obj,h,min_isi)
            if size(h.v,2) > 1
                h.v = h.v';
            end
            spikepos = nan(round(numel(h.v)/5e3),1);
            nbrofspikes = 0;
            startpos = 1;
            while startpos < numel(h.v) - obj.width
                stoppos = min(startpos+obj.max_matrix_size,numel(h.v));
                stoppos = stoppos-obj.width;
                spikepos_temp = (startpos:stoppos)';
                spikepos_temp = spikepos_temp( (h.v(obj.position_offset(1)+spikepos_temp) - h.v(spikepos_temp)) ...
                    >= (obj.v_offset(1) + obj.lower_tolerance(1)) );
                spikepos_temp = spikepos_temp( ( h.v(obj.position_offset(1)+spikepos_temp) - h.v(spikepos_temp)) ...
                    <= (obj.v_offset(1) + obj.upper_tolerance(1)) );
                for k=2:numel(obj.position_offset)
                    spikepos_temp = spikepos_temp( (h.v(obj.position_offset(k)+spikepos_temp) - h.v(spikepos_temp)) ...
                        >= (obj.v_offset(k) + obj.lower_tolerance(k)) );
                    spikepos_temp = spikepos_temp( (h.v(obj.position_offset(k)+spikepos_temp) - h.v(spikepos_temp)) ...
                        <= (obj.v_offset(k) + obj.upper_tolerance(k)) );
                end
                spikepos(nbrofspikes+1:nbrofspikes+numel(spikepos_temp)) = spikepos_temp;
                nbrofspikes = nbrofspikes + numel(spikepos_temp);
                startpos = stoppos+1;
            end
            spikepos = spikepos(1:nbrofspikes);
            spikepos = sc_separate(spikepos,min_isi);
            if nargout>=2
                wfarea = false(size(h.v));
                batchsize = round(obj.max_matrix_size/obj.width);
                for startpos = 1:batchsize:numel(spikepos)
                    endpos = min(startpos+batchsize,numel(spikepos));
                    wfs = bsxfun(@plus,spikepos(startpos:endpos),0:(obj.width-1));
                    wfarea(wfs(:)) = true(size(wfs(:)));
                end
            end
            spikepos = sc_separate(spikepos,obj.width);
        end
        
        %see ScWaveform for explanation
        function [spikepos, wfarea] = match(obj,v,min_isi)
            h.v = v;
            clear v;
            if nargout==1
                spikepos = obj.match_handle(h,min_isi);
            else
                [spikepos,wfarea] = obj.match_handle(h,min_isi);
            end
        end
        
        function n = get.n(obj)
            n = numel(obj.position_offset);
        end
        
        function width = get.width(obj)
            width = max(obj.position_offset);
        end
    end
    
end