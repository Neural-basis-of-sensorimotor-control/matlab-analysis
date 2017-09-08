function move_object(obj)

if ~isempty(obj.active_object)
  
  p = get(obj.h_axes,'CurrentPoint');
  
  x_ = p(1,1);
  y_ = p(1,2);
  
  obj.update_active_objects(x_, y_);
  
end

end