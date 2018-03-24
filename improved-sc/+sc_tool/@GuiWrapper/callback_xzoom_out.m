function callback_xzoom_out(obj, ~, ~ )

xl = xlim(obj.signal1_axes);
xdiff   = diff(xl);
xl = xl + [-xdiff/2 xdiff/2];
xlim(obj.signal1_axes, xl);

end