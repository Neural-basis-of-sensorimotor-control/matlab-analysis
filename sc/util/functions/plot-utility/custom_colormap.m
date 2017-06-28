function val = custom_colormap(colorindx, n)

if nargin<2
  n = 64;
end

val = zeros(n,3);
dt = .5/n;
color = .5:dt:1;
color = color';
color(length(color)>n) = [];

val(:,colorindx) = color;
% inactive_colors = true(1,3);
% inactive_colors(colorindx) = false;
% val(:,inactive_colors) = repmat(1-color, 1, 2);

end