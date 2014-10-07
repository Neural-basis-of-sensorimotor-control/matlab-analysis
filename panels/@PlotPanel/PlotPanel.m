classdef PlotPanel < SequenceDependentPanel
    properties
    end
    methods
        function obj = PlotPanel(gui)
            panel = uipanel('Parent',gui.current_view,'Title','Plot options');
            obj@SequenceDependentPanel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(OffsetAtTime(obj));
            obj.gui_components.add(SweepOptions(obj));
            obj.gui_components.add(ZoomOptions(obj));
            obj.gui_components.add(ThresholdOptions(obj));
            obj.gui_components.add(ManualSpikeTimes(obj));
            obj.gui_components.add(SavePlotOptions(obj));
        end
        
        function update_panel(obj)
            obj.dbg_in(mfilename,'update_panel','enabled = ',obj.enabled);
            update_panel@SequenceDependentPanel(obj);
            if obj.enabled
                obj.enabled = false;
            end
            if ~isempty(obj.gui.sequence)
                obj.gui.plot_channels();
            end
            obj.dbg_out(mfilename,'update_panel','enabled = ',obj.enabled);
        end
    end
    
    methods
        
    end
end