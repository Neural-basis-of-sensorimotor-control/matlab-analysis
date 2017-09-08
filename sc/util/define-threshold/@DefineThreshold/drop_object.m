function drop_object(obj)

if ~isempty(obj.active_object)
  
  p = get(obj.h_axes,'CurrentPoint');
  
  x_ = p(1,1);
  y_ = p(1,2);
  
  if obj.active_object_type == ThresholdObjects.STARTING_POINT
    
    dx_ = x_ - obj.x0;
    
    if any(obj.threshold.position_offset < round(dx_/obj.dt))
      
      obj.update_active_objects(obj.x0, obj.y0);
      obj.reset_active_objects();
      
      fprintf('Starting point must be to the left of all limits\n');
      
      return
      
    end
    
  else
    
    x_reset = obj.x0 + obj.threshold.position_offset(obj.active_index)*obj.dt;
    y_reset = obj.y0 + obj.threshold.v_offset(obj.active_index);
    
    if x_ <= obj.x0
      
      obj.update_active_objects(x_reset, y_reset);
      obj.reset_active_objects();
      
      fprintf('Cannot move left of starting point\n');
      
      return
      
    end
    
    if obj.active_index == ThresholdObjects.LOWER_BOUND && ...
        y_ >= y_reset + obj.threshold.upper_tolerance(obj.active_index)
      
      y_reset = y_reset + obj.threshold.lower_tolerance(obj.active_index);
      
      obj.update_active_objects(x_reset, y_reset);
      obj.reset_active_objects();
      
      fprintf('Bottom bound must be lower than top bound\n');
      
      return
      
    elseif obj.active_index == ThresholdObjects.UPPER_BOUND && ...
        y_ <= y_reset + obj.threshold.lower_tolerance(obj.active_index)
      
      y_reset = y_reset + obj.threshold.upper_tolerance(obj.active_index);
      
      obj.update_active_objects(x_reset, y_reset);
      obj.reset_active_objects();
      
      fprintf('Top bound must be higher than bottom bound\n');
      
      return
      
    end
    
  end
  
  obj.update_active_objects(x_, y_);
  
  if obj.active_object_type == ThresholdObjects.LOWER_BOUND   || ...
      obj.active_object_type == ThresholdObjects.UPPER_BOUND
    
    obj.threshold.position_offset(obj.active_index) = ...
      round((x_ - obj.x0)/obj.dt);
    
  end
  
  if obj.active_object_type == ThresholdObjects.LOWER_BOUND
    
    obj.threshold.lower_tolerance(obj.active_index) = ...
      y_ - obj.y0 - obj.threshold.v_offset(obj.active_index);
    
  elseif obj.active_object_type == ThresholdObjects.UPPER_BOUND
    
    obj.threshold.upper_tolerance(obj.active_index) = ...
      y_ - obj.y0 - obj.threshold.v_offset(obj.active_index);
    
  elseif obj.active_object_type == ThresholdObjects.STARTING_POINT
    
    obj.threshold.position_offset = obj.threshold.position_offset + round((x_ - obj.x0)/obj.dt);
    obj.threshold.v_offset        = obj.threshold.v_offset + y_ - obj.y0;
    
    obj.x0 = x_;
    obj.y0 = y_;
    
  end
  
  obj.threshold.min_isi = max(obj.threshold.position_offset);
  
  obj.reset_active_objects();
  
end

end