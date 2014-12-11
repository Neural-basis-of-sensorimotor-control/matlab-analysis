classdef ModePanel < Panel
    methods 
        function obj = ModePanel(gui)
            panel = uipanel('Parent',gui.btn_window,'Title','Mode Selection');
            obj@Panel(gui,panel);
            obj.layout();
        end
        function setup_components(obj)
            obj.gui_components.add(ModeSelection(obj));
        end
    end
end