classdef ChannelAxes < handle
    
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
        function obj = ChannelAxes(gui)
            obj.ax = axes;
            obj.gui = gui;
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
        
        function sequence = get.sequence(obj)
            sequence = obj.gui.sequence;
        end
        
        function sweep = setup_axes(obj,varargin)
            sweep = obj.gui.sweep;
            for k=1:2:numel(varargin)
                switch varargin{k}
                    case 'sweep'
                        sweep = varargin{k+1};
                end
            end
            cla(obj.ax);
            hold(obj.ax,'on');
            xlim(obj.ax,obj.gui.xlimits);
        end
        
    end
end