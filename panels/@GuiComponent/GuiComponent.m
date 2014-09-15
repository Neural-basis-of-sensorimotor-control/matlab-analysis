classdef GuiComponent < UiWrapper
    properties
        gui
    end
    
    methods
        
        function dbg_in(obj,varargin)
            obj.gui.dbg_in(varargin{:});
        end
        
        function dbg_out(obj,varargin)
            obj.gui.dbg_out(varargin{:});
        end
        
        function obj = GuiComponent(gui,uihandle)
            obj@UiWrapper(uihandle);
            obj.gui = gui;
        end
    end
end