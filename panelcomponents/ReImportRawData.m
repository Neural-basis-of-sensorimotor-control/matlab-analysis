classdef ReImportRawData < PanelComponent
    % Use this functionality when channels have been added to raw data files.
    % Only for Spike2 projects.
    methods
        function obj = ReImportRawData(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            tooltip = sprintf('Use this functionality when channels have been added to raw data files.\n Only for Spike2 projects.');
            mgr.add(sc_ctrl('pushbutton','Read raw data again',...
                @(~,~) obj.read_raw_data_callback(),...
                'ToolTipString',tooltip),200);
        end
        function read_raw_data_callback(obj)
            obj.gui.experiment.add_spike2_channels();
            obj.gui.has_unsaved_changes = true;
        end
    end
end