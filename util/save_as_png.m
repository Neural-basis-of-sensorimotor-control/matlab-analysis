function save_as_png(figs)

if ~nargin
  figs = gcf;
end

for i=1:length(figs)
  update_fig_name(figs(i));
  print(figs(i), figs(i).FileName, '-dpng');
end

end