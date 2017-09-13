function dblx(h_axes)

if ~nargin
  h_axes = gca;
end

xl = xlim(h_axes);
xl = mean(xl) + [-1 1]*diff(xl);

xlim(h_axes, xl)

end