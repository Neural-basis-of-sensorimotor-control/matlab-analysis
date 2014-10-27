classdef GuiAxes < handle
    properties (SetAccess = 'private', GetAccess = 'private')
        gui_manager
    end
    
    properties (SetObservable)
        ax_pr
        gui
        height = 300
    end
    properties (Dependent)
        sequence
        ax
    end
    methods (Abstract)
        load_data(obj)
        clear_data(obj)
        plotch(obj,varargin)
    end
    methods
        
        function obj = GuiAxes(gui)
            obj.gui = gui;
            obj.ax = axes;
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
        
        function val = get.ax(obj)
            if isempty(obj.ax_pr) || ~ishandle(obj.ax_pr)
                obj.ax_pr = axes;
            end
            val = obj.ax_pr;
        end
        function set.ax(obj,val)
            if ~isempty(obj.ax_pr) && ishandle(obj.ax_pr)
                delete(obj.ax_pr)
            end
            obj.ax_pr = val;
        end
    end
    methods (Access='protected')   
        
    end
end