classdef PlotPanel < Panel
    properties
    end
    methods
        function obj = PlotPanel(gui)
            panel = uipanel('Parent',gui.current_view,'Title','Plot options');
            obj@Panel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(OffsetAtTime(obj));
            obj.gui_components.add(SweepOptions(obj));
            obj.gui_components.add(ZoomOptions(obj));
            obj.gui_components.add(PlotOptions(obj));
            obj.gui_components.add(ThresholdOptions(obj));
            obj.gui_components.add(SavePlotOptions(obj));
        end
    end
end