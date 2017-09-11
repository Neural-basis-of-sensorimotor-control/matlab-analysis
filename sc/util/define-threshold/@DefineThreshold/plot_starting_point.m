function plot_starting_point(obj, x_, y_)

obj.all_objects = [];

h_plot = plot(obj.h_axes, x_, y_, 'Marker', 's', ...
  'Color', 'b', 'MarkerSize', 12, 'LineWidth', 2, ...
  'ButtonDownFcn', ...
  @(src, ~) drag_object(obj, ...
  DefineThresholdGraphicObjects.STARTING_POINT, src, src, 0));

obj.all_objects = add_to_list(obj.all_objects, h_plot);

plot_limits(obj);

end