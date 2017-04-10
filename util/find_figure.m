function find_figure(tag)

figs = get_all_figures();

figs = get_items(figs, 'Tag', tag);

if isempty(figs)
  fprintf('Figure does not exist');
end
  
for i=1:length(figs)
  figure(figs);
end

end