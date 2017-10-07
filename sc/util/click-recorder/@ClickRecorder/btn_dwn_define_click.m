function btn_dwn_define_click(obj)

selection_type = get(obj.h_axes.Parent, 'SelectionType');

if strcmp(selection_type, 'open')
  
  indx = find(arrayfun(@(point) isempty(point.x), obj.clicked_points), 1);
  
  if ~isempty(indx)
    
    p  = get(obj.h_axes, 'CurrentPoint');
    x_ = p(1, 1);
    y_ = p(1, 2);
    
    add_point(obj, indx, x_, y_)
    
  end
  
end

reset_axes(obj);
draw_objects(obj);

end