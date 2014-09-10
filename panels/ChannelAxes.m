classdef ChannelAxes < sc_gui.GuiAxes
    
    methods
        function obj = ChannelAxes(gui)
            obj@sc_gui.GuiAxes(gui);
        end
        
        function sweep = setup_axes(obj)%,varargin)
            switch obj.gui.plotmode
                case {sc_gui.PlotModes.default sc_gui.PlotModes.plot_avg_selected ...
                        sc_gui.PlotModes.plot_avg_std_selected}
                    sweep = obj.gui.sweep;
                case {sc_gui.PlotModes.plot_all sc_gui.PlotModes.plot_avg_all ...
                        sc_gui.PlotModes.plot_avg_std_all}
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