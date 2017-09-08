function plot_startpoint(obj)

h_starting_point = plot(obj.h_axes, obj.x0, obj.y0, 'Color', 'b', ...
  'Marker', 's', 'MarkerSize', 12);

set(h_starting_point, 'ButtonDownFcn', ...
  @(~,~) obj.drag_object(0, ThresholdObjects.STARTING_POINT, ...
  h_starting_point, h_starting_point));

end
