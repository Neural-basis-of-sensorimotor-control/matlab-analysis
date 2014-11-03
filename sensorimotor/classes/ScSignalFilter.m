classdef ScSignalFilter < handle
    properties (SetObservable)
        parent
        smoothing_width = 5
        artifact_width = 0%1e3
        artifactchannels
    end
    
    methods
        function obj = ScSignalFilter(parent)
            obj.parent = parent;
            obj.artifactchannels = ScList();
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
            v = obj.smoothing(v);
            v = obj.artifact_removal(v,tmin,tmax);
        end
        function v = smoothing(obj,v)
            v = filter(ones(1,obj.smoothing_width)/obj.smoothing_width,1,v);
        end
        function v = artifact_removal(obj,v,tmin,tmax)
            if obj.artifact_width
                for i=1:obj.artifactchannels.n
                    stimtimes = obj.artifactchannels.get(i).gettimes(tmin,tmax);
                    if numel(stimtimes)>=10
                        stimpos = round((stimtimes-tmin)/obj.parent.dt)+1;
                        v = sc_remove_artifacts(v,obj.artifact_width,stimpos);
                    end
                end
            end
        end
    end
    
end