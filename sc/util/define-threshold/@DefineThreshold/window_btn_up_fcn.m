function window_btn_up_fcn(obj)

if ~isempty(obj.active_object)
  
  active_object       = obj.active_object;
  active_object_group = obj.active_object_group;
  active_object_type  = obj.active_object_type;
  active_index        = obj.active_index;
  all_objects         = obj.all_objects;
  
  p = get(obj.h_axes, 'CurrentPoint');
  
  x_ = p(1, 1);
  y_ = p(1, 2);
  
  switch active_object_type
    
    case DefineThresholdGraphicObjects.STARTING_POINT
 
      dx    = x_ - obj.x0;
      dy    = y_ - obj.y0;
      
      obj.x       = obj.x + dx;
      obj.y_upper = obj.y_upper + dy;
      obj.y_lower = obj.y_lower + dy;
      
      obj.x0 = x_;
      obj.y0 = y_;
      
      DefineThreshold.update_starting_point(active_object, x_, y_);
      DefineThreshold.move_limits(all_objects(all_objects ~= active_object), dx, dy);
      
    case DefineThresholdGraphicObjects.LOWER_BOUND
      
      if x_ < obj.x0
        
        x_ = obj.x(active_index);
        y_ = obj.y_lower(active_index);
        
        fprintf('x < x0, discarding\n');
        
      elseif y_ >= obj.y_upper(active_index)
        
        x_ = obj.x(active_index);
        y_ = obj.y_lower(active_index);
        
        fprintf('y_lower >= y_upper, discarding\n');
        
      else
        
        obj.x(active_index)       = x_;
        obj.y_lower(active_index) = y_;
        obj.has_unsaved_changes   = true;
        
      end
      
      DefineThreshold.update_lower_bound(active_object, active_object_group, x_, y_);
      
    case DefineThresholdGraphicObjects.UPPER_BOUND
      
      if x_ < obj.x0
        
        x_ = obj.x(active_index);
        y_ = obj.y_upper(active_index);
        
        fprintf('x < x0, discarding\n');
        
      elseif y_ <= obj.y_lower(active_index)
        
        x_ = obj.x(active_index);
        y_ = obj.y_upper(active_index);
        
        fprintf('y_upper <= y_lower, discarding\n');
        
      else
        
        obj.x(active_index)       = x_;
        obj.y_upper(active_index) = y_;
        obj.has_unsaved_changes   = true;
        
      end
      
      DefineThreshold.update_upper_bound(active_object, active_object_group, x_, y_);
      
    case DefineThresholdGraphicObjects.BAR
      
      if x_ < obj.x0
        
        x_ = obj.x(active_index);
        
        fprintf('x < x0, discarding\n');
        
      else
        
        obj.x(active_index)     = x_;
        obj.has_unsaved_changes = true;
                
      end
      
      DefineThreshold.update_bar(active_object, active_object_group, x_);

    otherwise
      
      error('Illegal option: %d', active_object_type);
      
  end
  
end

clear_objects(obj);

end