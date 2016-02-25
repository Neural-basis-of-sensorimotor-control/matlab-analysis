classdef ScAmplitude < handle
    properties
        parent_signal
        labels
        stimtimes
        data
        tag
    end
    properties (Dependent)
        tstart
        tstop
    end
    
    methods
        function obj = ScAmplitude(parent_sequence, parent_signal, trigger, labels, tag, offset)
            obj.labels = labels;
            obj.parent_signal = parent_signal;
            obj.stimtimes = trigger.gettimes(parent_sequence.tmin,parent_sequence.tmax) + offset;
            obj.data = nan(numel(obj.stimtimes),numel(labels));
            obj.tag = tag;
        end
        
        function add_data(obj, stimtime, ind, x)
            [~,pos] = min(abs(stimtime-obj.stimtimes));
            for k=1:numel(ind)
                obj.data(pos,ind(k)) = (x(k));
            end
        end
        
        function val = get_data(obj, stimtime, ind)
            if nargin<3,    ind = numel(obj.labels);    end
            [~,pos] = min(abs(stimtime-obj.stimtimes));
            val = nan(size(ind));
            for k=1:numel(ind)
                if isfinite(obj.data(pos,ind(k)))
                    val(k) = obj.data(pos,ind(k));
                end
            end
        end
        
        function times  =  gettimes(obj, tmin, tmax)
            times = obj.stimtimes(obj.stimtimes >= tmin & obj.stimtimes < tmax);
        end
        
        function ret = get.tstart(obj)
            if isempty(obj.stimtimes)
                ret = inf;
            else
                ret = min(obj.stimtimes);
            end
        end
        function ret = get.tstop(obj)
            if isempty(obj.stimtimes)
                ret = -inf;
            else
                ret = max(obj.stimtimes);
            end
        end
    end
end