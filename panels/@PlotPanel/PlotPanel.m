classdef PlotPanel < UpdatablePanel%SequenceDependentPanel
    properties
    end
    methods
        function obj = PlotPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Plot options');
            obj@UpdatablePanel(gui,panel);
            obj.layout();
        end
        
        function setup_components(obj)
            obj.gui_components.add(OffsetAtTime(obj));
            obj.gui_components.add(SweepOptions(obj));
            obj.gui_components.add(AbsoluteTime(obj));
            obj.gui_components.add(ZoomOptions(obj));
            obj.gui_components.add(ThresholdOptions(obj));
            obj.gui_components.add(RemoveWaveformAll(obj));
            obj.gui_components.add(PlotMode(obj));
            obj.gui_components.add(ManualSpikeTimes(obj));
            obj.gui_components.add(SavePlotOptions(obj));
            obj.gui_components.add(SaveSpikeTimesOptions(obj));
            setup_components@UpdatablePanel(obj);
        end
        
        function initialize_panel(obj)
            initialize_panel@UpdatablePanel(obj);
        end
        
        function update_panel(obj)
            update_panel@UpdatablePanel(obj);
            if obj.enabled    
                obj.gui.plot_channels();
            end
        end
    end
    
    methods
        
    end
end