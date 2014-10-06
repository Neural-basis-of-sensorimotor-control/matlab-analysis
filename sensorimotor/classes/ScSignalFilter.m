classdef ScSignalFilter < handle
    properties (SetObservable) 
        parent
        smoothing_width = 5
        artifact_width = 1e3
        artifactchannels
        remove_waveforms
    end
    
    methods
        function obj = ScSignalFilter(parent)
            obj.parent = parent;
            obj.artifactchannels = ScList();
            obj.remove_waveforms = ScList();
        end
        
        %add all stim channels from parent file to artifact filter
        function update_stims(obj)
            stimchannels = obj.parent.parent.stims;
            for i=1:stimchannels.n
                stimchannel = stimchannels.get(i);
                if stimchannel.istrigger()
                    obj.artifactchannels.add(stimchannel);
                elseif strcmp(stimchannel.tag,'DigMark')
                    obj.artifactchannels.add(stimchannel.triggers.get('tag','1000'));
                else
                    for j=1:stimchannel.triggers.n
                        obj.artifactchannels.add(stimchannel.triggers.get(j));
                    end
                end
            end
        end
        
        function v = filt(obj,v,tmin,tmax)
            v = filter(ones(1,obj.smoothing_width)/obj.smoothing_width,1,v);
            if obj.artifact_width
                for i=1:obj.artifactchannels.n
                    stimtimes = obj.artifactchannels.get(i).gettimes(tmin,tmax);
                    if numel(stimtimes)>=10
                        stimpos = round((stimtimes-tmin)/obj.parent.dt)+1;
                        v = sc_remove_artifacts(v,obj.artifact_width,stimpos);
                    end
                end
            end
            for k=1:obj.remove_waveforms.n
                wf = obj.remove_waveforms.get(k);
                stimpos = round(wf.gettimes(0,inf)/obj.parent.dt);
                below_one = find(stimpos<1);
                above_max = find(stimpos>obj.parent.N);
                stimpos(below_one) = ones(size(below_one));
                stimpos(above_max) = obj.parent.N*ones(size(above_max));
                v = sc_remove_artifacts(v,wf.width,stimpos);
            end
        end
        
        function add_waveform(obj,waveform)
            obj.remove_waveforms_list.add(waveform);
        end
    end
    
    methods (Static)
        function obj = loadobj(a)
            if isempty(a.remove_waveforms)
                a.remove_waveforms = ScList();
            end
            obj = a;
        end
    end
end