function plot_limit(obj, indx)

x_ = obj.x0 + obj.threshold.position_offset(indx)*obj.dt;
y_ = obj.y0 + obj.threshold.v_offset(indx);

lower_ = y_ + obj.threshold.lower_tolerance(indx);
upper_ = y_ + obj.threshold.upper_tolerance(indx);

h_bar            = plot(x_*[1 1], [lower_ upper_], 'LineWidth', 2, 'Color', 'b');

h_upper_endpoint = plot(x_,       upper_,          'Marker', 's', 'MarkerSize', 12, 'Color', 'b');

h_lower_endpoint = plot(x_,       lower_,          'Marker', 's', 'MarkerSize', 12, 'Color', 'b');

h_plots          = [h_bar h_lower_endpoint h_upper_endpoint];

set(h_bar, 'UIContextMenu', create_context_menu(obj, indx));

set(h_lower_endpoint, 'ButtonDownFcn', ...
  @(~,~) obj.drag_object(indx, ThresholdObjects.LOWER_BOUND, h_lower_endpoint, h_plots), ...
  'UIContextMenu', create_context_menu(obj, indx));

set(h_upper_endpoint, 'ButtonDownFcn', ...
  @(~,~) obj.drag_object(indx, ThresholdObjects.UPPER_BOUND, h_upper_endpoint, h_plots), ...
  'UIContextMenu', create_context_menu(obj, indx));

end


function cmenu = create_context_menu(obj, indx)

cmenu = uicontextmenu();
uimenu(cmenu, 'Label', 'Remove', 'Callback', ...
  @(~,~) obj.remove_limit(indx))

end