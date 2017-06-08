function add_diagonal()

h = gca;

xl = xlim(h);
yl = ylim(h);

xymin = min(xl(1), yl(1));
xymax = max(xl(2), yl(2));

plot([xymin xymax], [xymin xymax]);

end