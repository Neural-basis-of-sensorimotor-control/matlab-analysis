function define_slope_stop_btndwn(obj, ~, ~)

p = get(gca, 'CurrentPoint');

x1 = p(1,1);
y1 = p(1,2);

if x1<=obj.x0
	obj.spike
	return
end

width = round((x1 - obj.x0)/obj.dt);
height = y1 - obj.y0;

if ~obj.spike.n
	lower_tol = -.1*height;
	upper_tol = .1*height;
else
	lower_tol = obj.spike.lower_tol(obj.spike.n);
	upper_tol = obj.spike.upper_tol(obj.spike.n);
end

obj.spike.width = add_to_list(obj.spike.width, width);
obj.spike.height = add_to_list(obj.spike.height, height);
obj.spike.lower_tol = add_to_list(obj.spike.lower_tol, lower_tol);
obj.spike.upper_tol = add_to_list(obj.spike.upper_tol, upper_tol);
obj.spike.min_isi = sum(obj.spike.height);

obj.x0 = x1;
obj.y0 = y1;

obj.define_slope_stop_update();

obj.update_fcn = @obj.define_slope_stop_update;


end
