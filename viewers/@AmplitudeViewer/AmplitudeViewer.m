classdef AmplitudeViewer < SequenceViewer
    methods
        function obj = AmplitudeViewer(guimanager,varargin)
            obj@SequenceViewer(guimanager,varargin{:});
%             addlistener(obj,'sequence','PostSet',@(~,~) obj.sequence_listener());
%             addlistener(obj,'triggerparent','PostSet',@(~,~) obj.triggerparent_listener);            
        end
        function add_constant_panels(obj)
            obj.panels.add(UpdatePanel(obj));
            obj.panels.add(InfoPanel(obj));
        end
        function add_dynamic_panels(obj)
            obj.panels.add(ChannelPanel(obj));
            obj.panels.add(PlotPanel(obj));
            obj.panels.add(HistogramPanel(obj));
        end
        function delete_dynamic_panels(obj)
            for k=obj.panels.n:-1:3
                panel = obj.panels.get(k);
                obj.panels.remove(panel);
                delete(panel);
            end
        end
    end
    methods (Static)
        function val = mode(~)
            val = ScGuiState.ampl_analysis;
        end
    end
end