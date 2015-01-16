classdef AutomaticUpdate < PanelComponent
    properties
        ui_automatic_update
    end
    methods
        function obj = AutomaticUpdate(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_automatic_update = mgr.add(sc_ctrl('checkbox',...
                'Automatic update',@(~,~) obj.automatic_update_callback()),200);
            set(obj.ui_automatic_update,'Value',obj.gui.automatic_update_on);
        end
        function automatic_update_callback(obj)
            obj.gui.automatic_update_on = get(obj.ui_automatic_update,'Value');
        end
    end
end