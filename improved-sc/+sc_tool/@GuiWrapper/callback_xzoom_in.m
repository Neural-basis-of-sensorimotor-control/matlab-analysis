function callback_xzoom_in(obj, ~, ~)

xl = xlim(obj.signal1_axes);

xdiff = diff(xl);
xl(1) = xl(1) + xdiff/4;
xl(2) = xl(2) - xdiff/4;

xlim(obj.signal1_axes, xl);
        
end