function init_plot(obj)

zoom off
hold on

reset_axes(obj);

set(obj.h_axes, 'ButtonDownFcn', @(~, ~) btn_dwn_define_click(obj));

h_plots = get_plots(obj.h_axes);

for i=1:length(h_plots)
  
  if get_nbr_of_samples(h_plots(i)) > 2
    
    set(h_plots(i), 'ButtonDownFcn', @(~, ~) btn_dwn_define_click(obj));
  
  end
  
end

end