classdef WaveformViewer < SequenceViewer
    
    methods (Static)
        function enum = mode
            enum = ScGuiState.spike_detection;
        end
    end
    
    methods
        function obj = WaveformViewer(varargin)
            obj@SequenceViewer(varargin{:});
            obj.main_channel = AnalogAxes(obj);
        end
        
        function add_panels(obj)
            obj.panels.add(InfoPanel(obj));
            %obj.panels.add(
        end
    end
end