function add_threshold_automatically_btn_dwn(obj, src, max_width, nbr_of_steps, lower_tol, upper_tol)

p = get(obj.h_axes, 'CurrentPoint');

x_ = p(1,1);
y_ = p(1,2);

obj.x0 = x_;
obj.y0 = y_;

xdata = get(src, 'XData');
ydata = get(src, 'YData');

[~, ind] = min(abs(xdata - x_));

incr = max_width/nbr_of_steps;

pos = round((incr:incr:max_width)/obj.dt);

obj.threshold.position_offset = pos;
obj.threshold.v_offset        = ydata(ind + pos) - y_;
obj.threshold.lower_tolerance = lower_tol*ones(size(pos));
obj.threshold.upper_tolerance = upper_tol*ones(size(pos));

obj.define_threshold();

end
