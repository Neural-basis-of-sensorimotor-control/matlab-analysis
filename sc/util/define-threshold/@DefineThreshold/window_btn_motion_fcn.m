function window_btn_motion_fcn(obj)

if ~isempty(obj.active_object)
  
  active_object       = obj.active_object;
  active_object_group = obj.active_object_group;
  active_object_type  = obj.active_object_type;
  
  p = get(obj.h_axes, 'CurrentPoint');
  
  x_ = p(1, 1);
  y_ = p(1, 2);
  
  switch active_object_type
    
    case DefineThresholdGraphicObjects.STARTING_POINT
      
      DefineThreshold.update_starting_point(active_object, x_, y_);
      
    case DefineThresholdGraphicObjects.LOWER_BOUND
      
      DefineThreshold.update_lower_bound(active_object, active_object_group, x_, y_);
      
    case DefineThresholdGraphicObjects.UPPER_BOUND
      
      DefineThreshold.update_upper_bound(active_object, active_object_group, x_, y_);
      
    otherwise
      
      error('Illegal object type: %d', active_object_type);
      
  end
  
end



