classdef GuiComponent < handle
    properties
        gui
    end
    
    methods
        function obj = GuiComponent(gui)
            obj.gui = gui;
        end
    end
end