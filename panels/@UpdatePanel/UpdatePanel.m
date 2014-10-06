classdef UpdatePanel < Panel
    
    methods
        function obj = UpdatePanel(gui)
            panel = uipanel('Parent',gui.current_view,'Title','Update');
            obj@Panel(gui,panel);
            obj.layout();
            obj.enabled = true;
        end
        
        function setup_components(obj)   
            obj.gui_components.add(UpdateButton(obj));
            obj.gui_components.add(HelpBox(obj));
        end
    end
    
end