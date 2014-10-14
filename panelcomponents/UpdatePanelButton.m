classdef UpdatePanelButton < PanelComponent
    methods
        function obj = UpdatePanelButton(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','UPDATE',@(~,~) obj.update_callback()),200);
        end
    end
    methods (Access = 'protected')
        function update_callback(obj)
            clc
            obj.gui.lock_screen(true,'Wait, updating gui...');
            index = obj.gui.panels.indexof(obj.panel);
            obj.panel.update_panel();
            if obj.panel.enabled
                for k=index+1:obj.gui.panels.n
                    panel = obj.gui.panels.get(k);
                    panel.initialize_panel();
                    panel.update_panel();
                    if ~panel.enabled
                        break;
                    end
                end
            end
            obj.gui.lock_screen(false);
        end
    end
end