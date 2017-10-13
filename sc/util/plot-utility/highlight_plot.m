function highlight_plot(tag, ax)

if nargin<2
  ax = gca;
end

plots = get_plots(ax);

for i=1:length(plots)
  
  if strcmp(plots(i).Tag, tag)
    linewidth = 2;
  else
    linewidth = 1;
  end
  
  set(plots(i), 'LineWidth', linewidth);
    
end

end