function btn_dwn_define_starting_point(obj)

p = get(obj.h_axes, 'CurrentPoint');

x_ = p(1, 1);
y_ = p(1, 2);

obj.x0 = x_;
obj.y0 = y_;

plot_starting_point(obj, x_, y_);

end