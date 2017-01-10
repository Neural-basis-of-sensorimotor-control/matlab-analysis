function sc_add_x_eq_y(ax)

axis(ax, 'equal');

xl = xlim(ax);
yl = ylim(ax);

if xl(1)>0
  xlim(ax, [0 xl(2)]);
end

if yl(1)>0
  ylim(ax, [0 yl(2)]);
end

xl = xlim(ax);
yl = ylim(ax);

is_hold = ishold(ax);

hold(ax, 'on')

minx = xl(1);
maxx = xl(2);

miny = yl(1);
maxy = yl(2);

start = max(minx, miny);
stop = min(maxx, maxy);

plot([start stop], [start stop], 'k');

if ~is_hold
  hold(ax, 'off');
end

end