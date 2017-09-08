function add_limits(obj, ~)

p = get(obj.h_axes, 'CurrentPoint');

x_ = p(1,1);
y_ = p(1,2);

if isempty(obj.x0)
  
  obj.x0 = x_;
  obj.y0 = y_;
  
  obj.plot_startpoint()
  
elseif x_ <= obj.x0
	
  fprintf('x1 < x0, ignoring input\n');
  
else
  
  position_offset   = round((x_ - obj.x0)/obj.dt);
  v_offset          = y_ - obj.y0;

  if ~obj.threshold.n
    
    height          = .1*sc_range(ylim(obj.h_axes));
  
  else
    
    height = (obj.threshold.upper_tolerance(obj.threshold.n) - ...
      obj.threshold.lower_tolerance(obj.threshold.n))/2;
    
  end

  lower_tolerance = -height;
  upper_tolerance = height;
  
  obj.threshold.position_offset = add_to_list(obj.threshold.position_offset, position_offset);
  obj.threshold.v_offset        = add_to_list(obj.threshold.v_offset, v_offset);
  obj.threshold.lower_tolerance = add_to_list(obj.threshold.lower_tolerance, lower_tolerance);
  obj.threshold.upper_tolerance = add_to_list(obj.threshold.upper_tolerance, upper_tolerance);
  obj.threshold.min_isi         = max(obj.threshold.position_offset);
  
  obj.plot_limit(obj.threshold.n);
  
end

obj.reset_active_objects();

set(obj.h_axes.Parent, 'WindowButtonMotionFcn', @(~,~) obj.move_object());
set(obj.h_axes.Parent, 'WindowButtonUpFcn',     @(~,~) obj.drop_object());
      
end
