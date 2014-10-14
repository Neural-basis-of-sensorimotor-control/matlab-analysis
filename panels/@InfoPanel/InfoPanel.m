classdef InfoPanel < UpdatablePanel
    properties
        panel_is_populated = false
    end
    methods
        function obj = InfoPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Main');
            obj@UpdatablePanel(gui,panel);
            obj.layout();
            addlistener(panel,'BeingDeleted','PostSet',@(~,~) obj.being_deleted_fcn);
        end
        
        function layout(obj)
            layout@Panel(obj);
            obj.panel_is_populated = true;
        end
        
        function setup_components(obj)   
            obj.gui_components.add(SaveLoadButton(obj));
            obj.gui_components.add(ExperimentOptions(obj));
            obj.gui_components.add(SequenceOptions(obj));
            obj.gui_components.add(SequenceTextBox(obj));
            if ~isempty(obj.gui.sequence)
                obj.gui_components.add(ModeSelection(obj));
                obj.gui_components.add(ChannelOptions(obj));
            end
            setup_components@UpdatablePanel(obj);
        end
        
        function update_panel(obj)
            update_panel@Panel(obj);
            obj.gui.show(obj.enabled);
            if isempty(obj.gui.sequence)
                obj.enabled = false;
            end
        end
        
        function initialize_panel(obj)
            if obj.panel_is_populated
                initialize_panel@Panel(obj);
            end
        end
        
    end
    
    methods (Access = 'protected')
        function being_deleted_fcn(obj)
            if get(obj.uihandle,'BeingDeleted')
                obj.panel_is_populated = false;
            end
        end
    end
end