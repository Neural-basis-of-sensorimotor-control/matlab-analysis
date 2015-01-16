classdef ReImportRawData < PanelComponent
    methods
        function obj = ReImportRawData(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','Read raw data again',@(~,~) obj.read_raw_data_callback()),200);
        end
        function read_raw_data_callback(obj)
            obj.gui.experiment.add_spike2_channels();
            obj.gui.has_unsaved_changes = true;
        end
    end
end