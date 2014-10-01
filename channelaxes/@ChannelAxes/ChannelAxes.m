classdef ChannelAxes < GuiAxes
    
    methods
        function obj = ChannelAxes(gui)
            obj@GuiAxes(gui);
        end
        
        function sweep = setup_axes(obj)%,varargin)
            switch obj.gui.plotmode
                case {PlotModes.default PlotModes.plot_avg_selected ...
                        PlotModes.plot_avg_std_selected}
                    sweep = obj.gui.sweep;
                case {PlotModes.plot_all PlotModes.plot_avg_all ...
                        PlotModes.plot_avg_std_all}
                    sweep = 1:numel(obj.gui.triggertimes);
            end
%             for k=1:2:numel(varargin)
%                 switch varargin{k}
%                     case 'sweep'
%                         sweep = varargin{k+1};
%                 end
%             end
            cla(obj.ax);
            hold(obj.ax,'on');
            xlim(obj.ax,obj.gui.xlimits);
        end
        
    end
end