classdef ScWaveform < ScTrigger & ScList
    properties
        parent
        spike2filename
        tag
        detected_spiketimes
        imported_spiketimes
        predefined_spiketimes
                
        min_isi = 1e-3
    end
    
%     properties (Dependent)
%         times
%     end
    
    methods
        function obj = ScWaveform(parent, tag, spike2filename)
            obj.parent = parent;
            obj.tag = tag;
            obj.spike2filename = spike2filename;
        end
        
%         function add(obj,thresholds,v)
%             add@ScList(obj,thresholds);
%             spiketimes = obj.parent.t(thresholds.match(v));
%             obj.detected_spiketimes = [obj.detected_spiketimes; spiketimes];
%         end
%         
%         function sc_clear(obj)    
%             obj.times = [];
%         end
        
        function sc_loadtimes(obj)
            if ~isempty(obj.spike2filename)
                d = load(fullfile(obj.parent.fdir,obj.spike2filename));
%                 spiketimes = d.spikes.times;
%                 obj.imported_spiketimes = spiketimes(spiketimes>=obj.parent.tmin & ...
%                     spiketimes < obj.parent.tmax);
                obj.imported_spiketimes = d.spikes.times;
            end
        end
        
        %Clear data that is loaded from external file
        function sc_clear(obj)
            obj.imported_spiketimes = [];
        end
        
        function [spikepos,wfarea] = match_handle(obj, h)
            if size(h.v,2)>size(h.v,1), 
                h.v=h.v';   
            end
            spikepos = nan(ceil(numel(v)/100),1);
            pos = 0;
            wfarea = false(size(h.v));
            for k=1:obj.n
                if nargout<2
                    spikepos_temp = obj.get(k).match_handle(h,obj.min_isi);
                else
                    [spikepos_temp, wfarea_temp] = obj.get(k).match_handle(h,obj.min_isi);
                    wfarea = wfarea | wfarea_temp;
                end
                spikepos(pos+1:pos+numel(spikepos_temp)) = spikepos_temp;
                pos = pos+numel(spikepos_temp);
            end
            spikepos = spikepos(1:pos);
        end
        
        function [spikepos, spikeindex] = match(obj,v)
            if size(v,2)>size(v,1), v=v';   end
            spikepos = nan(ceil(numel(v)/100),1);
            pos = 0;
            spikeindex = zeros(size(v));
            min_isi_pos = round(obj.min_isi/obj.parent.dt);
            for i=1:obj.n
                [spikepos_temp, wfarea] = obj.get(i).match(v,min_isi_pos);
                spikepos(pos+1:pos+numel(spikepos_temp)) = spikepos_temp;
                pos = pos+numel(spikepos_temp);
                spikeindex(wfarea) = i*ones(nnz(wfarea),1);
            end
            spikepos = spikepos(1:pos);
        end
        
%         function times = get.times(obj)  
%            times = sc_separate(sort([obj.detected_spiketimes; obj.imported_spiketimes; ...
%                obj.predefined_spiketimes]),obj.min_isi);
%         end

        function times = gettimes(obj,tmin,tmax)
               times = sc_separate(sort([obj.detected_spiketimes; obj.imported_spiketimes; ...
                   obj.predefined_spiketimes]),obj.min_isi);
               times = times(times>=tmin & times<tmax);
        end
        
        function recalculate_spiketimes(obj,v,dt)
            obj.detected_spiketimes = obj.match(v)*dt;
        end
    end
end