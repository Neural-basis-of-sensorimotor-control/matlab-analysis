classdef AutoEpspTemplate < hamo.templates.AutoThresholdTemplate
    
    properties 
        lower_cutoff = 15   % Lower cutoff freq for bandpass filter
        upper_cutoff = 1e4  % Upper cutoff freq for bandpass filter
    end
    
    methods
        
        function obj = AutoEpspTemplate(varargin)
            obj@hamo.templates.AutoThresholdTemplate(varargin{:});
        end
        
        % Override superclass function
        function plotSweep(obj, hAxes, time, sweep, triggerTime)
            filteredSweep = bandpass(sweep, ...
                [obj.lower_cutoff obj.upper_cutoff], 1/obj.dt);
            plotSweep@hamo.templates.AutoThresholdTemplate(obj, hAxes, ...
                time, filteredSweep, triggerTime);
        end
        
        % Override superclass function
        function match_v(obj, v)
            filteredSweep = bandpass(v, ...
                [obj.lower_cutoff obj.upper_cutoff], 1/obj.dt);
            match_v@hamo.templates.AutoThresholdTemplate(obj, filteredSweep);
        end
        
    end
    
end