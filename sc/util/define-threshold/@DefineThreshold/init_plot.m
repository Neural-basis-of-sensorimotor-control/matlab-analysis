function init_plot(obj)

set(obj.h_axes, 'ButtonDownFcn', @(~, ~) btn_dwn_define_starting_point(obj));

h_plots = get_plots(obj.h_axes);

for i=1:length(h_plots)
  
  if ~any(obj.all_objects == h_plots(i))
    
    set(h_plots(i), 'ButtonDownFcn', @(~, ~) btn_dwn_define_starting_point(obj));
  
  end
  
end

end