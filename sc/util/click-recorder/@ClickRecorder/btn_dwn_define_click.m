function btn_dwn_define_click(obj)

indx = find(arrayfun(@(point) isempty(point.x), obj.clicked_points), 1);
  
if ~isempty(indx)
  
  p  = get(obj.h_axes, 'CurrentPoint');
  x_ = p(1, 1);
  y_ = p(1, 2);
  
  obj.clicked_points(indx).x = x_;
  obj.clicked_points(indx).y = y_;

end

reset_axes(obj);
draw_objects(obj);

end