function h_plots = get_plots(h)

if isempty(h)
  
  h_plots = h;
  
elseif any(arrayfun(@isfigure, h))
  
  h_plots = [];
  
  for i=1:length(h)
    h_plots = concat_list(h_plots, get_plots(get_axes(h(i))));
  end
  
elseif any(arrayfun(@isaxes, h))
  
  h_plots = [];
  
  for i=1:length(h)
    h_plots = concat_list(h_plots, get_plots(h(i).Children));
  end
  
else
  
  h_plots = h(arrayfun(@isplot, h));

end

end