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
    
    
    function load_data(obj, remove_waveforms)
      
      if nargin<2
        remove_waveforms = true;
      end
      
      if obj.plot_raw
        s.smooth = true;
        s.remove_artifacts = false;
        s.remove_waveforms = false;
        s.remove_artifacts_simple = false;
        
        obj.v_raw = obj.signal.get_v(s);
        
        s.smooth = true;
        s.remove_artifacts = true;
        s.remove_waveforms = remove_waveforms;
        s.remove_artifacts_simple = true;
        
        obj.v = obj.signal.get_v(s);
      else
        obj.v_raw = [];
        
        s.smooth = true;
        s.remove_artifacts = true;
        s.remove_waveforms = remove_waveforms;
        s.remove_artifacts_simple = true;
        
        obj.v = obj.signal.get_v(s);
      end
      
      obj.extract_b_highlighted();
      obj.data_loaded = true;
    end
    
    
    function plotch(obj, btn_down_fcn)
      if nargin<=1
        btn_down_fcn = [];
      end
      
      sweep = obj.setup_axes();
      xlabel(obj.ax,'Time [s]');
      ylabel(obj.ax,obj.signal.tag);
      set(obj.ax,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0],...
        'Box','off');
      grid(obj.ax,'on');
      
      if ~isempty(sweep)
        if ~isempty(obj.v_raw)
          obj.plotv(obj.v_raw,sweep,[1 1 1],[],false);
          
          if ~isempty(obj.gui.rmwf)
            v_rmwf = zeros(size(obj.v_raw));
            v_rmwf = obj.gui.rmwf.remove_wf(v_rmwf);
            obj.plotv(-v_rmwf,sweep,[0 1 0],[],false);
          end
        end
        
        obj.plotv(obj.v,sweep,[1 0 0],btn_down_fcn,1);
      else
        cla(obj.ax);
      end
      
      xlim(obj.ax,obj.gui.xlimits);
    end
    
    
    function [v_out, time_out, handles_out] = plotv(obj,v_signal, sweep, plotcolor, btn_down_fcn, plothighlighted)
      handles = nan(size(v_signal,2));
      pretrigger = obj.gui.pretrigger;
      posttrigger = obj.gui.posttrigger;
      
      if pretrigger>obj.gui.xlimits(1)
        pretrigger = obj.gui.xlimits(1);
      end
      
      if posttrigger<obj.gui.xlimits(2)
        posttrigger = obj.gui.xlimits(2);
      end
      
      [v_signal,time] = sc_get_sweeps(v_signal, 0, obj.gui.triggertimes(sweep), ...
        pretrigger, posttrigger, obj.signal.dt);
      
      if ~isempty(obj.b_highlighted)
        b_signal = sc_get_sweeps(obj.b_highlighted, 0, obj.gui.triggertimes(sweep), ...
          pretrigger, posttrigger, ...
          obj.signal.dt);
      else
        b_signal = [];
      end
      
      if ~isempty(obj.v_equals_zero_for_t) && isfinite(obj.v_equals_zero_for_t)
        [~,ind] = min(abs(time-obj.v_equals_zero_for_t));
        
        for i=1:size(v_signal,2)
          v_signal(:,i) = v_signal(:,i) - v_signal(ind,i);
        end
      end
      
      if obj.gui.plotmode ~= PlotModes.plot_only_avg_std
        
        if isempty(b_signal) || ~plothighlighted
          for i=1:size(v_signal,2)
            plothandle = plot(obj.ax,time,v_signal(:,i),'Color',plotcolor);%,'LineWidth',2);
            
            if ~isempty(btn_down_fcn)
              set(plothandle,'ButtonDownFcn',btn_down_fcn);
              set(plothandle, 'HitTest', 'on');
            end
            handles(i) = plothandle;
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
      end
      
      if obj.gui.plotmode == PlotModes.plot_avg_all            || ...
          obj.gui.plotmode == PlotModes.plot_avg_selected      || ...
          obj.gui.plotmode == PlotModes.plot_avg_std_all       || ...
          obj.gui.plotmode == PlotModes.plot_avg_std_selected  ||...
          obj.gui.plotmode == PlotModes.plot_only_avg_std
        
        avg = mean(v_signal,2);
        plot(obj.ax,time,avg,'Color',[0 1 0],...
          'LineWidth',2);
      end
      
      if obj.gui.plotmode == PlotModes.plot_avg_std_all       || ...
          obj.gui.plotmode == PlotModes.plot_avg_std_selected || ...
          obj.gui.plotmode == PlotModes.plot_only_avg_std
        
        stddev = std(v_signal,0,2);
        plot(obj.ax,time,avg+stddev,'Color',[0 0 1],'LineWidth',2);
        plot(obj.ax,time,avg-stddev,'Color',[0 0 1],'LineWidth',2);
      end
      
      if nargout
        v_out = v_signal;
      end
      
      if nargout>=2
        time_out = time;
      end
      
      if nargout>=3
        handles_out = handles;
      end
    end
  end
  
  methods (Access='protected')
    
    function extract_b_highlighted(obj)
      if ~obj.plot_waveforms
        obj.b_highlighted = [];
      else
        obj.b_highlighted = false(size(obj.v));
        if ~isempty(obj.gui.waveform)
          [spikepos,obj.b_highlighted] = obj.gui.waveform.match_v(obj.v);
          obj.gui.waveform.detected_spiketimes = spikepos*obj.gui.waveform.parent.dt;
        end
      end
    end
    
  end
end
