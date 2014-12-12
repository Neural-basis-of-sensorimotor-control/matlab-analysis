classdef AmplAnalogAxes < AnalogAxes
    methods
        function obj = AmplAnalogAxes(varargin)
            obj@AnalogAxes(varargin{:});
        end
        function plotv(obj, v_signal, sweep, plotcolor, btn_down_fcn, plothighlighted)
            [v,time] = plotv@AnalogAxes(obj, v_signal, sweep, plotcolor, btn_down_fcn, plothighlighted);
            if size(v,2)==1
                if  ~isempty(btn_down_fcn)
                    warning('Button down function is already set');
                end
                [~,ind] = min(abs(time));
                text(obj.ax,0,double(v(ind)),'start','HorizontalAlignment',...
                    'center','Color',[0 1 0]);
                triggertime = obj.triggertimes(obj.sweep(1));
                val = obj.gui.amplitude.get_data(triggertime,1:4);
                if isfinite(val(1))
                    plot(obj.ax,val(1),val(2),'g+','MarkerSize',12,'LineWidth',4);
                end
                if isfinite(val(3))
                    plot(obj.ax,val(3),double(val(4)),'b+','MarkerSize',12,'LineWidth',4);
                end
            end
        end
    end
end