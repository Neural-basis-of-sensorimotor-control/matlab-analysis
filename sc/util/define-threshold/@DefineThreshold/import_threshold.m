function import_threshold(obj, threshold, dt)

if ~isempty(obj.x0)
  
  obj.x       = obj.x0 + threshold.position_offset*dt;
  obj.y_lower = obj.y0 + threshold.v_offset + threshold.lower_tolerance;
  obj.y_upper = obj.y0 + threshold.v_offset + threshold.upper_tolerance;
    
end

end