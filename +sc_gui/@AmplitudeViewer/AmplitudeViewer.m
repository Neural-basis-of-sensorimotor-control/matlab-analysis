classdef AmplitudeViewer < sc_gui.SequenceViewer
    
    properties (SetObservable)
        amplitude_set
    end
    
    properties (Dependent)
        triggertimes
    end
    
    methods (Static)
        function enum = mode
            enum = ScGuiState.ampl_analysis;
        end
    end
    
    methods
        function obj = AmplitudeViewer(sequence)
            obj@sc_gui.SequenceViewer(sequence);
        end
        
        function add_panels(obj)
            obj.add_main_panel();
            obj.add_channel_panel();
            obj.add_filter_panel();
            obj.add_plot_panel();
        end
        
        function times = get.triggertimes(obj)
            if isempty(obj.amplitude_set)
                times = [];
            else
                times = obj.amplitude_set.gettimes(obj.tmin,obj.tmax);
            end
        end
        
    end
end