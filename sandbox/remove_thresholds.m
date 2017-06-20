function remove_thresholds(h_has_unsaved_changes, h_axes, thresholds, x0, y0, dt)

if length(x0) == 1
  
  x0 = x0 * size(thresholds);
  y0 = y0 * size(thresholds);
  
end

edit_plot_handle    = EditPlotHandle(h_axes, h_has_unsaved_changes, dt);
edit_plot_handle.x0 = x0;
edit_plot_handle.y0 = y0;

hold(h_axes, 'on');

for i=1:length(thresholds)
  
  tmp_plots = plot_removable_threshold(edit_plot_handle, thresholds(i), x0(i), y0(i));
  
  for j=1:length(tmp_plots)
    set(tmp_plots(j), 'Tag', thresholds(i).tag);
  end
  
end

add_legend(edit_plot_handle.h_axes);

end