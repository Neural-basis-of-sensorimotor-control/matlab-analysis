classdef UpdateButton < PanelComponent
    %Update GUI
    methods
        function obj = UpdateButton(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','UPDATE',@(~,~) obj.update_callback,...
                'FontWeight','bold'),200);
            mgr.newline(20);
            ui_reset = mgr.add(sc_ctrl('pushbutton','Reset',@(~,~) obj.reset_callback),100);
            addlistener(ui_reset,'Enable','PostSet',@(src,~) set(src,'Enable','on'));
        end
    end
    
    methods (Access = 'protected')
        
        function update_callback(obj)
            clc
            obj.gui.lock_screen(true);
            obj.gui.panels.last_enabled_item.update_panel();
            obj.gui.lock_screen(false);
        end
        
        function reset_callback(obj)    
            obj.gui.lock_screen(false);
        end
    end
end