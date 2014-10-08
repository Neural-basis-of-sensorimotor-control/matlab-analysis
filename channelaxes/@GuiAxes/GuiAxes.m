classdef GuiAxes < handle
    properties (SetAccess = 'private', GetAccess = 'private')
        gui_manager
    end
    
    properties (SetObservable)
        ax
        gui
        height = 300
     %   postset_listener
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
                if ~isempty(obj.ax)
               %     if isobject(obj.ax)
                        obj.height = getheight(obj.ax);
               %     end
%                     if ~isempty(obj.postset_listener) && isobject(obj.postset_listener)
%                         delete(obj.postset_listener);
%                     end
                end
            end
            
            function ax_listener_post(~,~)
                if ~isempty(obj.ax)
                    set(obj.ax,'ActivePositionProperty','position');
                    setheight(obj.ax,obj.height);
                  %  obj.postset_listener = addlistener(obj.ax,'BeingDeleted','PostSet',@being_deleted_listener);
                    addlistener(obj.ax,'XLim','PostSet',@xlim_listener);
                    addlistener(obj.ax,'Position','PostSet',@(~,~) obj.axes_position_listener);
                    sc_addlistener(obj.gui,'xlimits',@xlimits_listener,obj.ax);
                end
                
%                 function being_deleted_listener(~,~)
%                     if get(obj.ax,'BeingDeleted')
%                         obj.height = getheight(obj.ax);
%                     end
%                 end
                
                function xlim_listener(~,~)
                    if obj.ax == obj.gui.main_axes
                        obj.gui.xlimits = xlim(obj.ax);
                    end
                end
                
                function xlimits_listener(~,~)
                    if obj.gui.xlimits(1) < obj.gui.xlimits(2)
                        xlim(obj.ax,obj.gui.xlimits);
                    end
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
    methods (Access='protected')   
        function axes_position_listener(obj)
            obj.height = getheight(obj.ax);
        end
    end
end