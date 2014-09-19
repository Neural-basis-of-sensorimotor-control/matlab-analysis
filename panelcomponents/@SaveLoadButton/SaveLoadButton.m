classdef SaveLoadButton < PanelComponent
    %Save and Load experiment data 
    properties
        ui_save
        ui_load
    end
    methods
        function obj = SaveLoadButton(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_save = mgr.add(sc_ctrl('pushbutton','Save',@save_callback),100);
            obj.ui_load = mgr.add(sc_ctrl('pushbutton','Load',@load_callback),100);
            
            sc_addlistener(obj.gui,'has_unsaved_changes',@has_unsaved_changes_listener,obj.uihandle);
            
            function save_callback(~,~)
                saved = obj.gui.sequence.sc_save();
                if saved
                    obj.gui.has_unsaved_changes = false;
                end
            end
            
            function load_callback(~,~)
                msgbox('to be implemented');
            end
            
            function has_unsaved_changes_listener(~,~)
                if obj.gui.has_unsaved_changes
                    set(obj.ui_save,'Enable','on');
                else
                    set(obj.ui_save,'Enable','off');
                end
            end
        end
    end
end