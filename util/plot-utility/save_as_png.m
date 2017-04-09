function save_as_png(figs)

if ~nargin
  figs = gcf;
end

for i=1:length(figs)
  update_fig_name(figs(i));
  try
  print(figs(i), figs(i).FileName, '-dpng');
  catch
    ii=.1
  end
end

end