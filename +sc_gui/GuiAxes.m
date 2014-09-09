classdef GuiAxes < handle
    properties
        ax
        gui
    end
    properties (Dependent)
        sequence
    end
    methods (Abstract)
        plotch(obj,varargin)
    end
    methods
        function obj = GuiAxes(gui)
            obj.ax = axes;
            obj.gui = gui;
        end
        function sequence = get.sequence(obj)
            sequence = obj.gui.sequence;
        end
        function set(obj,varargin)
            set(obj.ax,varargin{:});
        end
        
        function varargout = get(obj,varargin)
            varargout = get(obj.ax,varargin{:});
            if numel(varargout)
                varargout = {varargout};
            end
        end
    end
    
end