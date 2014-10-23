classdef AnalogAxes < ChannelAxes
    properties (SetObservable)
        data_loaded = false
        signal
        plot_raw = false
        plot_waveforms = false
        v_equals_zero_for_t     %leave empty to disable
    end
    
    properties (Transient)
        b_highlighted
        v_raw
        v
    end
    
    methods
        function obj = AnalogAxes(gui,signal)%,varargin)
            obj@ChannelAxes(gui);
            if nargin>1
                obj.signal = signal;
            end
        end
        
        function clear_data(obj)
            
            obj.data_loaded = false;
            obj.v = [];
            obj.v_raw = [];
            obj.b_highlighted = [];
        end
        
        function load_data(obj,apply_remove_waveforms)
            if nargin<2,    apply_remove_waveforms = true;   end
            obj.data_loaded = true;
            if obj.plot_raw
                obj.v_raw = obj.signal.sc_loadsignal();
                obj.v = obj.signal.filter.filt(obj.v_raw,0,inf);
            else
                obj.v_raw = [];
                obj.v = obj.signal.sc_loadsignal();
                obj.v = obj.signal.filter.filt(obj.v,0,inf);
            end
            if apply_remove_waveforms
                if obj.plot_waveforms
                    if obj.gui.waveform.apply_after == ScWaveformEnum.artifact_filtering
                        obj.extract_b_highlighted();
                        obj.remove_waveforms();
                    else
                        obj.remove_waveforms();
                        obj.extract_b_highlighted();
                    end
                else
                    obj.remove_waveforms();
                end
            elseif obj.plot_waveforms
                obj.extract_b_highlighted;
            end
        end
        
        function plotch(obj,btn_down_fcn)
            if nargin<=1,   btn_down_fcn = [];  end
            sweep = obj.setup_axes();
            xlabel(obj.ax,'Time [s]');
            ylabel(obj.ax,obj.signal.tag);
            set(obj.ax,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0],...
                'Box','off');
            grid(obj.ax,'on');
            if ~isempty(sweep)
                if ~isempty(obj.v_raw)
                    obj.plotv(obj.v_raw,sweep,[1 1 1],[],false);
                end
                obj.plotv(obj.v,sweep,[1 0 0],btn_down_fcn,1);
            else
                cla(obj.ax);
            end
            xlim(obj.ax,obj.gui.xlimits);
        end
        
        function plotv(obj,v_signal, sweep, plotcolor, btn_down_fcn, plothighlighted)
            [v_signal,time] = sc_get_sweeps(v_signal, 0, obj.gui.triggertimes(sweep), ...
                obj.gui.pretrigger, obj.gui.posttrigger, ...
                obj.signal.dt);
            if ~isempty(obj.b_highlighted)
                b_signal = sc_get_sweeps(obj.b_highlighted, 0, obj.gui.triggertimes(sweep), ...
                    obj.gui.pretrigger, obj.gui.posttrigger, ...
                    obj.signal.dt);
            else
                b_signal = [];
            end
            if ~isempty(obj.v_equals_zero_for_t)
                [~,ind] = min(abs(time-obj.v_equals_zero_for_t));
                for i=1:size(v_signal,2)
                    v_signal(:,i) = v_signal(:,i) - v_signal(ind,i);
                end
            end
            
            if isempty(b_signal) || ~plothighlighted
                for i=1:size(v_signal,2)
                    plothandle = plot(obj.ax,time,v_signal(:,i),'Color',plotcolor,'LineWidth',2);
                    if ~isempty(btn_down_fcn)
                        set(plothandle,'ButtonDownFcn',btn_down_fcn);
                    end
                end
            else
                for i=1:size(v_signal,2)
                    pos = b_signal(:,i);
                    plothandle = sc_piecewiseplot(obj.ax,time(pos),v_signal(pos,i),'Color',[0 1 0],'LineWidth',2);
                    if ~isempty(btn_down_fcn)
                        set(plothandle,'ButtonDownFcn',btn_down_fcn);
                    end
                end
                for i=1:size(v_signal,2)
                    pos = ~b_signal(:,i);
                    plothandle = sc_piecewiseplot(obj.ax,time(pos),v_signal(pos,i),'Color',plotcolor,'LineWidth',2);
                    if ~isempty(btn_down_fcn)
                        set(plothandle,'ButtonDownFcn',btn_down_fcn);
                    end
                end
            end
            if obj.gui.plotmode == PlotModes.plot_avg_all || ...
                    obj.gui.plotmode == PlotModes.plot_avg_selected || ...
                    obj.gui.plotmode == PlotModes.plot_avg_std_all || ...
                    obj.gui.plotmode == PlotModes.plot_avg_std_selected
                avg = mean(v_signal,2);
                plot(obj.ax,time,avg,'Color',[0 1 0],...
                    'LineWidth',2);
            end
            if obj.gui.plotmode == PlotModes.plot_avg_std_all || ...
                    obj.gui.plotmode == PlotModes.plot_avg_std_selected
                stddev = std(v_signal,0,2);
                plot(obj.ax,time,avg+stddev,'Color',[0 0 1],'LineWidth',2);
                plot(obj.ax,time,avg-stddev,'Color',[0 0 1],'LineWidth',2);
            end
        end
    end
    methods (Access='protected')
        function remove_waveforms(obj)
            for k=1:obj.signal.remove_waveforms.n
                obj.v = obj.signal.remove_waveforms.get(k).remove_wf(obj.v,0);
            end
        end
        function extract_b_highlighted(obj)
            obj.b_highlighted = false(size(obj.v));
            if ~isempty(obj.gui.waveform)
                [spikepos,obj.b_highlighted] = obj.gui.waveform.match_handle(obj);
                obj.gui.waveform.detected_spiketimes = spikepos*obj.gui.waveform.parent.dt;
            end
        end
    end
end