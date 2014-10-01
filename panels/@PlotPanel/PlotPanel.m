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
        
        function update_panel(obj)
            obj.dbg_in(mfilename,'update_panel','enabled = ',obj.enabled);
            update_panel@Panel(obj);
            if obj.enabled
                obj.enabled = false;
                set(obj,'visible','on');
                for k=1:obj.gui.plots.n
                    obj.gui.plots.get(k).plotch();
                end
            end
            obj.dbg_out(mfilename,'update_panel','enabled = ',obj.enabled);
        end
    end
    
    methods
        
    end
end