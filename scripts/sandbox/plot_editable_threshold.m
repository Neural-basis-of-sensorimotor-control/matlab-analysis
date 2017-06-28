function plots = plot_editable_threshold(edit_plot_handle, threshold, x0, y0, dt)

plots     = [];

x         = threshold.x;
y_lower   = threshold.y_lower;
y_upper   = threshold.y_upper;

for i=1:length(x)
  
  plots = add_to_list(plots, plot(edit_plot_handle.h_axes, x0 + x(i)*[1 1], y0 + [y_lower(i) y_upper(i)]*dt, '-', ...
    'ButtonDownFcn', ...
    @(src, ~) button_down_fcn(edit_plot_handle, threshold, i, 'bar', src)));
  
  plots = add_to_list(plots, plot(edit_plot_handle.h_axes, x0 + x(i), y0 + y_lower(i)*dt, 's', ...
    'ButtonDownFcn', ...
    @(src, ~) button_down_fcn(edit_plot_handle, threshold, i, 'lower', src)));
  
  plots = add_to_list(plots, plot(edit_plot_handle.h_axes, x0 + x(i), y0 + y_upper(i)*dt, 's', ...
    'ButtonDownFcn', ...
    @(src, ~) button_down_fcn(edit_plot_handle, threshold, i, 'upper', src)));
  
end

end


function button_down_fcn(edit_plot_handle, threshold, indx, type, src)

edit_plot_handle.threshold = threshold;
edit_plot_handle.indx      = indx;
edit_plot_handle.type      = type;edit
edit_plot_handle.src       = src;

plots = get_plots(edit_plot_handle.h_axes);

for i=1:length(plots)
  
  if strcmp(get(plots(i), 'Tag'), tag)
    set(plots(i), 'LineWidth', 2);
  else
    set(plots(i), 'LineWidth', 1);
  end
  
end

end