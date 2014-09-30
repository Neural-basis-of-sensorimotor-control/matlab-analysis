classdef UpdatePanel < Panel
    
    methods
        function obj = UpdatePanel(gui)
            panel = uipanel('Parent',gui.current_view);
            obj@Panel(gui,panel);
            obj.layout();
            obj.enabled = true;
        end
        
        function setup_components(obj)   
            obj.gui_components.add(UpdateButton(obj));
        end
    end
    
    methods (Static)
        function val = upper_margin()
            val = 2;
        end
    end
end