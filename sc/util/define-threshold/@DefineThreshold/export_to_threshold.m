function threshold = export_to_threshold(obj, dt, threshold)

if nargin < 3
  threshold = ScThreshold();
end

if isempty(obj.x)
  
  error('No limits. Discarding\n');
  
else
  
  dx                        = round((obj.x - obj.x0)/dt);
  v_offset                  = zeros(size(dx));
  dy_lower                  = obj.y_lower - obj.y0;
  dy_upper                  = obj.y_upper - obj.y0;
  
  threshold.position_offset = dx;
  threshold.v_offset        = v_offset;
  threshold.lower_tolerance = dy_lower;
  threshold.upper_tolerance = dy_upper;
  
end

end