function draw_objects(obj)

i = 1;

while i<=length(obj.clicked_points) && ~isempty(obj.clicked_points(i).x)
  
  tmp_clicked_point = obj.clicked_points(i);
  
  if isempty(tmp_clicked_point)
    break
  end
  
  h_label = text(tmp_clicked_point.x, tmp_clicked_point.y, num2str(i), ...
    'FontSize', 14);
  
  h_plot = plot(tmp_clicked_point.x, tmp_clicked_point.y, ...
    'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'ButtonDownFcn', @(src, ~) drag_object(obj, src, h_label, i));
  
  obj.all_objects = add_to_list(obj.all_objects, h_plot);
  obj.all_objects = add_to_list(obj.all_objects, h_label);
  
  i = i + 1;
  
end

h_figure = get(obj.h_axes, 'Parent');

set(h_figure, 'WindowButtonMotionFcn', @(~,~) window_btn_motion_fcn(obj));

set(h_figure, 'WindowButtonUpFcn',     @(~,~) window_btn_up_fcn(obj));

end