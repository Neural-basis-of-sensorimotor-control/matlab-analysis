function update_active_objects(obj, x_, y_)

for i=1:length(obj.active_object_group)
    
    tmp_object = obj.active_object_group(i);
    xdata_     = get(tmp_object, 'XData');
    ydata_     = sort(get(tmp_object, 'YData'));
    
    if length(xdata_) > 1
      
      xdata_ = x_*[1 1];
      
      if obj.active_object_type == ThresholdObjects.LOWER_BOUND
        ydata_(1) = y_;
      elseif obj.active_object_type == ThresholdObjects.UPPER_BOUND
        ydata_(2) = y_;
      end
      
    else
      
      xdata_ = x_;
      
      if obj.active_object == tmp_object
        ydata_ = y_;
      end
      
    end
    
    set(tmp_object, 'XData', xdata_, 'YData', ydata_);
    
end
  
end