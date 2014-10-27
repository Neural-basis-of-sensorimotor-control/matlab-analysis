classdef ChannelAxes < GuiAxes
    
    methods
        function obj = ChannelAxes(gui)
            obj@GuiAxes(gui);
            addlistener(obj,'ax_pr','PostSet',@(~,~) obj.ax_pr_listener_post);
        end
        
        function sweep = setup_axes(obj)
            switch obj.gui.plotmode
                case {PlotModes.default PlotModes.plot_avg_selected ...
                        PlotModes.plot_avg_std_selected}
                    sweep = obj.gui.sweep;
                case {PlotModes.plot_all PlotModes.plot_avg_all ...
                        PlotModes.plot_avg_std_all}
                    sweep = 1:numel(obj.gui.triggertimes);
            end
            cla(obj.ax);
            hold(obj.ax,'on');
            xlim(obj.ax,obj.gui.xlimits);
        end
        
    end
    methods (Access='protected')
        function axes_position_listener(obj)
            obj.height = getheight(obj.ax);
        end
        function ax_pr_listener_post(obj)
            if ~isempty(obj.ax)
                set(obj.ax,'ActivePositionProperty','position');
                setheight(obj.ax,obj.height);
                addlistener(obj.ax,'XLim','PostSet',@(~,~) obj.xlim_listener);
                addlistener(obj.ax,'Position','PostSet',@(~,~) obj.axes_position_listener);
                sc_addlistener(obj.gui,'xlimits',@(~,~) obj.xlimits_listener,obj.ax);
            end
        end
        function xlim_listener(obj)
            if obj.ax == obj.gui.main_axes
                obj.gui.xlimits = xlim(obj.ax);
            end
        end
        
        function xlimits_listener(obj)
            if obj.gui.xlimits(1) < obj.gui.xlimits(2)
                xlim(obj.ax,obj.gui.xlimits);
            end
        end
    end
end