classdef GuiComponent < UiWrapper
    properties
        gui
    end
    
    methods  
        function obj = GuiComponent(gui,uihandle)
            obj@UiWrapper(uihandle);
            obj.gui = gui;
        end
    end
end