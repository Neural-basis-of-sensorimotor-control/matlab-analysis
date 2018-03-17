function plot_starting_point(obj, x_, y_)

for i=1:length(obj.all_objects)
  
  delete(obj.all_objects(i));
  
end

obj.all_objects = [];

h_plot = plot(obj.h_axes, x_, y_, 'Marker', 's', ...
  'Color', obj.color, 'MarkerSize', 12, 'LineWidth', 2, ...
  'ButtonDownFcn', ...
  @(src, ~) drag_object(obj, ...
  DefineThresholdGraphicObjects.STARTING_POINT, src, src, 0));

obj.all_objects = add_to_list(obj.all_objects, h_plot);

set(obj.h_axes, 'ButtonDownFcn', @(~,~) add_limit(obj));

end