function define_slope_stop_update(obj)

haxis = axis;

cla
plot(obj.x, obj.y, 'ButtonDownFcn', @obj.define_slope_stop_btndwn);
hold on

if obj.spike.n
	indx = obj.spike.n:-1:1;
	
	xx = obj.x0 - [0 cumsum(obj.spike.width(indx))*obj.dt];
	yy = obj.y0 - [0 cumsum(obj.spike.height(indx))];
	lower_tol = obj.spike.lower_tol([indx(1) indx]);
	upper_tol = obj.spike.upper_tol([indx(1) indx]);
	
	plot(xx, yy + lower_tol, xx, yy + upper_tol, ...
		'ButtonDownFcn', @obj.define_slope_stop_btndwn);
	
end

hold off

axis(haxis);

end