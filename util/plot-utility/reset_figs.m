function reset_figs()

figs = get_all_figures();

for i=1:length(figs)
  
  clf(figs(i), 'reset');
  
end

reset_fig_indx();