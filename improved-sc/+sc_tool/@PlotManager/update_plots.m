function update_plots(obj)

cla(obj.signal1_axes);
hold(obj.signal1_axes, 'on');

if isempty(obj.signal1)
  return
end

xlim(obj.signal1_axes, [obj.pretrigger obj.posttrigger]);
xlabel(obj.signal1_axes, 'Time [s]');
ylabel(obj.signal1_axes, obj.signal1.tag);
set(obj.signal1_axes, 'XColor', [1 1 1], 'YColor', [1 1 1], 'Color', ...
  [0 0 0], 'Box', 'off');
grid(obj.signal1_axes,'on');

switch obj.plot_mode
  case sc_tool.PlotModeEnum.plot_sweep
    obj.plot_sweep();
  case sc_tool.PlotModeEnum.plot_amplitude
    obj.plot_amplitude();
  case sc_tool.PlotModeEnum.edit_threshold
    obj.plot_edit_waveform();
end

end
