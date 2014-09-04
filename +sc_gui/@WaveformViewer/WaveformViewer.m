classdef WaveformViewer < sc_gui.SequenceViewer
    properties (SetObservable)
        triggerparent
        trigger
    end
    
    properties (Dependent)
        triggerparents
        triggers
        triggertimes
    end
    
    methods (Static)
        function enum = mode
            enum = ScGuiState.spike_detection;
        end
    end
    
    methods
        function obj = WaveformViewer(sequence)
            obj@sc_gui.SequenceViewer(sequence);
        end
        
        function add_panels(obj)
            obj.add_main_panel();
            obj.add_channel_panel();
            obj.add_filter_panel();
            obj.add_trigger_panel();
            obj.add_plot_panel();
            
        end
        
        function set_sweep(obj,sweep)
            obj.sweep = mod(sweep-1,numel(obj.triggertimes))+1;
            obj.plot_channels();
        end
               
        function triggerparents = get.triggerparents(obj)
            triggerparents = obj.sequence.gettriggerparents(obj.tmin, obj.tmax);
        end
        
        function triggers = get.triggers(obj)
            triggers = obj.triggerparent.triggers;
        end
        
        function triggertimes = get.triggertimes(obj)
            if isempty(obj.trigger)
                triggertimes = [];
            else
                triggertimes = obj.trigger.gettimes(obj.tmin,obj.tmax);
            end
        end
    end
end