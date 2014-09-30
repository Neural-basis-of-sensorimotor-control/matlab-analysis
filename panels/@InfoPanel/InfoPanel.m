classdef InfoPanel < Panel
    methods
        function obj = InfoPanel(gui)
            panel = uipanel('Parent',gui.current_view,'Title','Main');
            obj@Panel(gui,panel);
            obj.layout();
            obj.enabled = true;
        end
        
        function setup_components(obj)   
%            obj.gui_components.add(UpdateButton(obj));
            obj.gui_components.add(SaveLoadButton(obj));
            obj.gui_components.add(ModeSelection(obj));
            obj.gui_components.add(MainPanel(obj));
            obj.gui_components.add(SequenceOptions(obj));
            obj.gui_components.add(SequenceTextBox(obj));
            obj.gui_components.add(ChannelOptions(obj));
        end
        
        function update_panel(obj)
            update_panel@Panel(obj);
            obj.gui.show();
        end
        
    end
end