classdef SaveLoadButton < PanelComponent
    %Save and Load experiment data
    properties
        ui_save
        ui_load
        ui_new_sp2
        ui_new_adq
    end
    methods
        function obj = SaveLoadButton(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_save = mgr.add(sc_ctrl('pushbutton','Save',@(~,~) obj.save_callback),100);
            obj.ui_load = mgr.add(sc_ctrl('pushbutton','Load',@(~,~) obj.load_callback),100);
            mgr.newline(20);
            obj.ui_new_sp2 = mgr.add(sc_ctrl('pushbutton','New Spike2 set',@(~,~) obj.new_sp2_set),100);
            obj.ui_new_adq = mgr.add(sc_ctrl('pushbutton','New .adq set',@(~,~) obj.new_adq_set),100);
            sc_addlistener(obj.gui,'has_unsaved_changes',@(~,~) obj.has_unsaved_changes_listener,obj.uihandle);
        end
    end
    methods (Access='protected')
        function save_callback(obj)
            saved = obj.gui.sequence.sc_save();
            if saved
                obj.gui.has_unsaved_changes = false;
            end
        end
        
        function load_callback(~)
            sc -loadnew;
        end
        
        function new_sp2_set(~)
            sc -newsp2;
        end
        
        function new_adq_set(~)
            sc -newadq;
        end
        
        function has_unsaved_changes_listener(obj)
            if obj.gui.has_unsaved_changes
                set(obj.ui_save,'Enable','on');
            else
                set(obj.ui_save,'Enable','off');
            end
        end
    end
end