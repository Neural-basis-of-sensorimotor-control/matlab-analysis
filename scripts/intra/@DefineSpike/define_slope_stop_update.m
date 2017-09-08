function define_slope_stop_update(obj)

hold(obj.h_axes, 'on')

for i=1:obj.threshold.n
  
  x_ = obj.x0 + obj.threshold.position_offset(i)*obj.dt;
  y_ = obj.y0 + obj.threshold.position_offset(i);
  
  lower_ = y_ + obj.threshold.lower_tolerance(i);
  upper_ = y_ + obj.threshold.upper_tolerance(i);
  
  plot(x_ * [1 1], [lower_ upper_], ...
    'ButtonDownFcn', @obj.define_slope_stop_btndwn);
	
end

hold(obj.h_axes, 'off')

end