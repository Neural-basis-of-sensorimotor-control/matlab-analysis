classdef UpdateButton < PanelComponent
    properties
        ui_update
    end
    
    methods
        function obj = UpdateButton(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_update = mgr.add(sc_ctrl('pushbutton','UPDATE',@update_callback,...
                'FontWeight','bold'),200);
            
            function update_callback(~,~)
                obj.gui.panels.last_enabled_item.update_panel();
            end
        end
    end
end