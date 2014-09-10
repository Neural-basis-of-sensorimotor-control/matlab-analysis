classdef UpdateButton < GuiComponent
    properties
        ui_update
    end
    
    methods
        function obj = UpdateButton(gui)
            obj@GuiComponent(gui);
        end
        
        function populate_panel(obj,mgr)
            mgr.newline(40);
            obj.ui_update = mgr.add(sc_ctrl('pushbutton','UPDATE',@update_callback,...
                'FontWeight','bold'),200);
            
            function update_callback(~,~)
                obj.gui.get_last_enabled_item().update();
            end
        end
    end
end