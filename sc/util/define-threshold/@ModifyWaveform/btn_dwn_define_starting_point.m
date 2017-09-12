function btn_dwn_define_starting_point(obj)

p = get(obj.h_axes, 'CurrentPoint');

x_    = p(1, 1);
y_    = p(1, 2);

for i=1:length(obj.thresholds)
  
  obj.thresholds(i).x0 = x_;
  obj.thresholds(i).y0 = y_;
  
  plot_starting_point(obj.thresholds(i), x_, y_);
  
end

end