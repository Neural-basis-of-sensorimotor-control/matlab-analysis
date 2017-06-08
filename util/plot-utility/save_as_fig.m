function save_as_fig(figs)

if ~nargin
  figs = gcf;
end

for i=1:length(figs)
  update_fig_name(figs(i), 'fig');
  savefig(figs(i), figs(i).FileName);
end

end
