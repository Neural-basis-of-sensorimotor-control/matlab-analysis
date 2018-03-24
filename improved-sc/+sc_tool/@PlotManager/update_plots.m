function update_plots(obj)

if isempty(obj.signal1) || isempty(obj.plot_mode)
  return
end

obj.reset_axes(obj.trigger_axes, []);
obj.reset_axes(obj.signal1_axes, obj.signal1.tag);
obj.reset_axes(obj.signal2_axes, nmpty(obj.signal2));

if obj.plot_mode == sc_tool.PlotModeEnum.plot_sweep
  
  obj.plot_sweep();
  
% elseif obj.plot_mode == sc_tool.PlotModeEnum.plot_amplitude
%   
%   obj.plot_amplitude();
  
elseif obj.plot_mode == sc_tool.PlotModeEnum.edit_threshold
  
  obj.plot_edit_waveform();
  
elseif (obj.plot_mode == sc_tool.PlotModeEnum.plot_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_all)
  
  [v, time] = obj.plot_all();
  
elseif (obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_selected)
  
  [v, time] = obj.plot_all(obj.trigger_indx);
  
elseif obj.plot_mode == sc_tool.PlotModeEnum.plot_only_avg_std_all
  
  [v, time] = sc_get_sweeps(obj.v1, 0, obj.all_trigger_times, obj.pretrigger, ...
    obj.posttrigger, obj.signal1.dt);
  
else
  
  error('Illegal value of plot_mode: %s\n', obj.plot_mode)
  
end

if (obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_only_avg_std_all)
  
  avg       = mean(v, 2);
  plot(obj.signal1_axes, time, avg, 'Color', [0 1 0], 'LineWidth', 2);
  
end

if (obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_all || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_avg_std_selected || ...
    obj.plot_mode == sc_tool.PlotModeEnum.plot_only_avg_std_all)
  
  stddev = std(v, 0, 2);
  plot(obj.signal1_axes, time, avg + stddev, 'Color', [0 0 1], ...
    'LineWidth', 2);
  plot(obj.signal1_axes, time, avg - stddev, 'Color', [0 0 1], ...
    'LineWidth', 2);
  
end

end
