function define_slope_stop_btndwn(obj, ~, ~)

p = get(obj.h_axes, 'CurrentPoint');

x1 = p(1,1);
y1 = p(1,2);

if isempty(obj.x0)
  
  obj.x0 = x1;
  obj.y0 = y1;
  
  hold(obj.h_axes, 'on')
  plot(obj.h_axes, obj.x0, obj.y0, 'Marker', 's', 'ButtonDownFcn', @obj.define_slope_stop_btndwn);
  hold(obj.h_axes, 'off')
  
elseif x1 <= obj.x0
	
  fprintf('x1 < x0, ignoring input\n');
  
else
  
  position_offset   = round((x1 - obj.x0)/obj.dt);
  v_offset          = y1 - obj.y0;

  if ~obj.threshold.n
	
    lower_tolerance = -.1*v_offset;
    upper_tolerance = .1*v_offset;

  else
    
    lower_tolerance = obj.threshold.lower_tolerance(obj.threshold.n);
    upper_tolerance = obj.threshold.upper_tolerance(obj.threshold.n);
    
  end

  obj.threshold.position_offset = add_to_list(obj.threshold.position_offset, position_offset);
  obj.threshold.v_offset        = add_to_list(obj.threshold.v_offset, v_offset);
  obj.threshold.lower_tolerance = add_to_list(obj.threshold.lower_tolerance, lower_tolerance);
  obj.threshold.upper_tolerance = add_to_list(obj.threshold.upper_tolerance, upper_tolerance);
  obj.threshold.min_isi         = sum(obj.threshold.position_offset);

  obj.define_slope_stop_update();

  obj.update_fcn = @obj.define_slope_stop_update;

end

end
