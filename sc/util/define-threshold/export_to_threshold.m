function threshold = export_to_threshold(obj, dt)

if isempty(obj.x)
  
  error('No limits. Discarding\n');
  
else
  
  dx       = round(obj.x - obj.x0)/dt;
  dy_lower = obj.y_lower - obj.y0;
  dy_upper = obj.y_upper - obj.y0;
  

  threshold = ScThreshold(dx, zeros(size(dx)), dy_lower, dy_upper);
  
end