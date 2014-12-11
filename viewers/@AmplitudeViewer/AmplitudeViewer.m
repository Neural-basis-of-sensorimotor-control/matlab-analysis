classdef AmplitudeViewer < SequenceViewer
    properties (SetObservable)
        amplitude
    end
    properties (Dependent)
        triggertimes
        nbr_of_constant_panels
    end
    
    methods
        function obj = AmplitudeViewer(guimanager,varargin)
            obj@SequenceViewer(guimanager,varargin{:});
            obj.av_setup_listeners();
        end
        function add_constant_panels(obj)
            obj.panels.add(InfoPanel(obj));
        end
        function add_dynamic_panels(obj)
            obj.panels.add(AmplChannelPanel(obj));
            obj.panels.add(AmplPlotPanel(obj));
            obj.panels.add(HistogramPanel(obj));
        end
        function delete_dynamic_panels(obj)
            %todo - replace hardcoded number with function
            for k=obj.panels.n:-1:obj.nbr_of_constant_panels+1
                panel = obj.panels.get(k);
                obj.panels.remove(panel);
                delete(panel);
            end
        end
        function ret = get.triggertimes(obj)
            if isempty(obj.amplitude)
                ret = [];
            else
                ret = obj.amplitude.gettimes(obj.tmin,obj.tmax);
            end
        end
        function ret = get.nbr_of_constant_panels(~)
            ret = 3;
        end
    end
    
    methods (Static)
        function val = mode(~)
            val = ScGuiState.ampl_analysis;
        end
    end
end