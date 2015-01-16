classdef InfoPanel < UpdatablePanel
    properties
        dynamic_panels_exist = false
    end
    methods
        function obj = InfoPanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Main');
            obj@UpdatablePanel(gui,panel);
            obj.layout();
        end
        
        function layout(obj)
            layout@Panel(obj);
        end
        
        function setup_components(obj)   
            obj.gui_components.add(AutomaticUpdate(obj));
            obj.gui_components.add(ReImportRawData(obj));
            obj.gui_components.add(SaveLoadButton(obj));
            obj.gui_components.add(ExperimentOptions(obj));
            obj.gui_components.add(SequenceOptions(obj));
            obj.gui_components.add(SequenceTextBox(obj));
            obj.gui_components.add(FileCommentTextBox(obj));
            obj.gui_components.add(ChannelOptions(obj));
            setup_components@UpdatablePanel(obj);
        end
        
        function update_panel(obj)
            update_panel@Panel(obj);
            if isempty(obj.gui.sequence)
                obj.enabled = false;
            elseif obj.enabled && ~obj.dynamic_panels_exist
                obj.gui.add_dynamic_panels();
                obj.dynamic_panels_exist = true;
                for k=obj.gui.nbr_of_constant_panels+1:obj.gui.panels.n
                    panel = obj.gui.panels.get(k);
                    panel.initialize_panel();
                    panel.update_panel();
                    if ~panel.enabled
                        break;
                    end
                end
                obj.gui.resize_btn_window();
            end
        end
        
    end
    
    methods %(Access = 'protected')
        function enabled_listener(obj)
           if ~obj.enabled && obj.dynamic_panels_exist
               obj.gui.delete_dynamic_panels();
               obj.dynamic_panels_exist = false;
           end
           
        end
    end
end