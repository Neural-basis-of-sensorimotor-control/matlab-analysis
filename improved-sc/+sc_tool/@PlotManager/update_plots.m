function update_plots(obj)

if isempty(obj.signal1)
  return
end

obj.enabled = false;
drawnow

obj.reset_axes(obj.trigger_axes, []);
obj.reset_axes(obj.signal1_axes, obj.signal1.tag);
obj.reset_axes(obj.signal2_axes, nmpty(obj.signal2));

if obj.plot_mode == sc_tool.PlotModeEnum.plot_sweep
  
  obj.plot_sweep(obj.signal1_axes, obj.signal1, obj.v1);
  obj.plot_sweep(obj.signal2_axes, obj.signal2, obj.v2);
  
elseif (obj.plot_mode == sc_tool.PlotModeEnum.plot_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_all)
  
  [v1, t1] = obj.plot_all(obj.signal1_axes, obj.signal1, obj.v1);
  [v2, t2] = obj.plot_all(obj.signal2_axes, obj.signal2, obj.v2);
  
elseif (obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_selected)
  
  [v1, t1] = obj.plot_all(obj.signal1_axes, obj.signal1, obj.v1, obj.trigger_indx);
  [v2, t2] = obj.plot_all(obj.signal2_axes, obj.signal2, obj.v2, obj.trigger_indx);
  
elseif obj.plot_mode == sc_tool.PlotModeEnum.plot_only_avg_std_all
  
  [v1, t1] = sc_get_sweeps(obj.v1, 0, obj.all_trigger_times, obj.pretrigger, ...
    obj.posttrigger, obj.signal1.dt);
  
  if isempty(obj.signal2_axes)
    
    v2 = [];
    t2 = [];
    
  else
    
    [v2, t2] = sc_get_sweeps(obj.v2, 0, obj.all_trigger_times, obj.pretrigger, ...
      obj.posttrigger, obj.signal2.dt);
    
  end
  
else
  
  error('Illegal value of plot_mode: %s\n', obj.plot_mode)
  
end

if (obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_only_avg_std_all)
  
  avg1 = mean(v1, 2);
  plot(obj.signal1_axes, t1, avg1, 'Color', [0 1 0], 'LineWidth', 2);
  
  if ~isempty(obj.signal2_axes)
    
    avg2 = mean(v2, 2);
    plot(obj.signal2_axes, t2, avg2, 'Color', [0 1 0], 'LineWidth', 2);
    
  end
  
end

if (obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_only_avg_std_all)
  
  stddev1 = std(v1, 0, 2);
  plot(obj.signal1_axes, t1, avg1 + stddev1, 'Color', [0 0 1], ...
    'LineWidth', 2);
  plot(obj.signal1_axes, t1, avg1 - stddev1, 'Color', [0 0 1], ...
    'LineWidth', 2);
  
  if ~isempty(obj.signal2_axes)
    
    stddev2 = std(v2, 0, 2);
    plot(obj.signal2_axes, t2, avg2 + stddev2, 'Color', [0 0 1], ...
      'LineWidth', 2);
    plot(obj.signal2_axes, t2, avg2 - stddev2, 'Color', [0 0 1], ...
      'LineWidth', 2);
    
  end
  
end

if obj.interactive_mode
  
  obj.modify_waveform.init_plot();
  
end

obj.enabled = true;

end
