function edit_threshold_1(h_has_unsaved_changes, h_axes, thresholds, x0, y0, dt)

if length(x0) == 1
  
  x0 = x0 * size(thresholds);
  y0 = y0 * size(thresholds);
  
end


h_figure = get(h_axes, 'Parent');

edit_plot_handle = EditPlotHandle(h_axes, h_has_unsaved_changes, dt);
edit_plot_handle.x0 = x0;
edit_plot_handle.y0 = y0;

hold(h_axes, 'on');

for i=1:length(thresholds)
  
  tmp_plots = plot_editable_threshold(edit_plot_handle, thresholds(i), x0(i), y0(i));
  
  for j=1:length(tmp_plots)
    set(tmp_plots(j), 'Tag', thresholds(i).tag);
  end
  
end

add_legend(edit_plot_handle.h_axes);

set(h_figure, 'WindowButtonMotionFcn', @(~,~) move_endpoint(edit_plot_handle));

set(h_figure, 'WindowButtonUpFcn',     @(~,~) drop_endpoint(edit_plot_handle));

end


function move_endpoint(edit_plot_handle)

if ~isempty(edit_plot_handle.threshold)
  
  p   = get(edit_plot_handle.h_axes, 'CurrentPoint');
  tag   = get(src, 'Tag');
  plots = get_plots(edit_plot_handle.h_axes);
  
  x = p(1, 1);
  y = p(1, 2);
  
  for j=1:length(plots)
    
    if strcmp(get(plots(j), 'Tag'), tag)
      set(plots(j), 'XData', x);
    end
    
  end
  
  if strcmpi(edit_plot_handle.type, 'lower') || ...
      strcmpi(edit_plot_handle.type, 'upper')
    
    set(src, 'YData', y);
    
  end
  
end

end


function drop_endpoint(edit_plot_handle)

if ~isempty(edit_plot_handle.threshold)
  
  p     = get(edit_plot_handle.h_axes, 'CurrentPoint');
  tag   = get(src, 'Tag');
  plots = get_plots(edit_plot_handle.h_axes);
  
  x = p(1, 1);
  y = p(1, 2);
  
  for j=1:length(plots)
    
    if strcmp(get(plots(j), 'Tag'), tag)
      set(plots(j), 'XData', x);
    end
    
  end
  
  if strcmpi(edit_plot_handle.type, 'lower') || ...
      strcmpi(edit_plot_handle.type, 'upper')
    
    set(src, 'YData', y);
    
  end
  
  dx = round((x - edit_plot_handle.x0(edit_plot_handle.indx))/edit_plot_handle.dt);
  dy = y - edit_plot_handle.y0(edit_plot_handle.indx);
  
  switch (edit_plot_handle.type)
    
    case 'lower'
      edit_plot_handle.threshold.y_lower(edit_plot_handle.indx) = dy;
    case 'upper'
      edit_plot_handle.threshold.y_upper(edit_plot_handle.indx) = dy;
  end
  
  edit_plot_handle.threshold.x(edit_plot_handle.indx)        = dx;
  edit_plot_handle.h_has_unsaved_changes.has_unsaved_changes = true;
    
end

end

