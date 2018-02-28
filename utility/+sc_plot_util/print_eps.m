function print_eps(filename, fig)
%print_eps(filename, fig)

if nargin < 2
  fig = gcf;
end

figure(fig);

print('-painters', '-depsc', '-cmyk', filename);

end