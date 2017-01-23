function add_square(x, y, c)

hold_mode = ishold;

if length(c) == 1
  c = repmat(c, size(x));
end

for i=1:length(x)
  xvalues = x(i) + [-.5 -.5 .5 .5 -.5];
  yvalues = y(i) + [-.5 .5 .5 -.5 -.5];
  fill(xvalues, yvalues, c(i));
end

if ~hold_mode
  hold('off')
end

end