function window_btn_up_fcn(obj)

if ~isempty(obj.active_object)
  
  p = get(obj.h_axes, 'CurrentPoint');
  
  x_ = p(1, 1);
  y_ = p(1, 2);
  
  set(obj.active_object, 'XData', x_, 'YData', y_);
  
  position = get(obj.active_label, 'Position');
  set(obj.active_label, 'Position', [x_ y_ position(3)]);
  
  update_clicked_points(obj, x_, y_);
    
end

clear_objects(obj);

end