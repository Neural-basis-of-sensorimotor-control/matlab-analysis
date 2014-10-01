classdef GuiAxes < handle
    properties (SetAccess = 'private', GetAccess = 'private')
        gui_manager
    end
    
    properties (SetObservable)
        ax
        gui
        height = 300
        postset_listener
    end
    properties (Dependent)
        sequence
    end
    methods (Abstract)
        load_data(obj)
        clear_data(obj)
        plotch(obj,varargin)
    end
    methods
        function dbg_in(obj,varargin)
            obj.gui.dbg_in(varargin{:});
        end
        
        function dbg_out(obj,varargin)
            obj.gui.dbg_out(varargin{:});
        end
        
        function obj = GuiAxes(gui)
            addlistener(obj,'ax','PreSet',@ax_listener_pre);
            addlistener(obj,'ax','PostSet',@ax_listener_post);
            
            obj.gui = gui;
            obj.ax = axes;
            %setheight(obj.ax,obj.height);
            
            function ax_listener_pre(~,~)
                obj.dbg_in(mfilename,'ax_listener_pre')
                if ~isempty(obj.ax)
                    if isobject(obj.ax)
                        obj.height = getheight(obj.ax);
                    end
                    if ~isempty(obj.postset_listener) && isobject(obj.postset_listener)
                        delete(obj.postset_listener);
                    end
                end
                obj.dbg_out(mfilename,'ax_listener_pre')
            end
            
            function ax_listener_post(~,~)
                obj.dbg_in(mfilename,'ax_listener_post')
                if ~isempty(obj.ax)
                    set(obj.ax,'ActivePositionProperty','position');
                    setheight(obj.ax,obj.height);
                    obj.postset_listener = addlistener(obj.ax,'BeingDeleted','PostSet',@being_deleted_listener);
                end
                obj.dbg_out(mfilename,'ax_listener_post')

                function being_deleted_listener(~,~)
                    obj.dbg_in(mfilename,'being_deleted_listener')
                    if get(obj.ax,'BeingDeleted')
                        obj.height = getheight(obj.ax);
                    end
                    obj.dbg_out(mfilename,'being_deleted_listener')
                end
            end
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