classdef UpdateButton < PanelComponent
    %Update GUI
    properties
        ui_reset
    end
    methods
        function obj = UpdateButton(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','UPDATE',@(~,~) obj.update_callback,...
                'FontWeight','bold'),200);
            mgr.newline(20);
            obj.ui_reset = mgr.add(sc_ctrl('pushbutton','Re-enable buttons',@(~,~) obj.reset_callback),200);
            obj.gui.reset_btn = obj.ui_reset;
        end
    end
    
    methods (Access = 'protected')
        
        function update_callback(obj)
            clc
            obj.gui.lock_screen(true,'Wait, updating gui...');
            set(obj.ui_reset,'Enable','on');
            obj.gui.panels.last_enabled_item.update_panel();
            obj.gui.lock_screen(false);
        end
        
        function reset_callback(obj)    
            obj.gui.lock_screen(false);
        end
        
    end
end