classdef PlotPanel < SequenceDependentPanel
    properties
    end
    methods
        function obj = PlotPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Plot options');
            obj@SequenceDependentPanel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(OffsetAtTime(obj));
            obj.gui_components.add(SweepOptions(obj));
            obj.gui_components.add(ZoomOptions(obj));
            obj.gui_components.add(ThresholdOptions(obj));
            obj.gui_components.add(PlotMode(obj));
            obj.gui_components.add(ManualSpikeTimes(obj));
            obj.gui_components.add(SavePlotOptions(obj));
        end
        
        function initialize_panel(obj)
            initialize_panel@SequenceDependentPanel(obj);
        %    if obj.enabled
                obj.gui.plot_channels();
        %    end
        end
        
        function update_panel(obj)
            obj.gui.zoom_controls = get(obj.uihandle,'children');
            obj.gui.sequence_listener;
            update_panel@SequenceDependentPanel(obj);
            if obj.enabled
                if ~isempty(obj.gui.sequence)
                    obj.gui.plot_channels();
                end
                obj.enabled = false;
            end
        end
    end
    
    methods
        
    end
end