function dbly(h_axes)

if ~nargin
  h_axes = gca;
end

yl = ylim(h_axes);
yl = mean(yl) + [-1 1]*diff(yl);

ylim(h_axes, yl)

end