function update_background_callbacks(obj)

h_figure = get(obj.h_axes, 'Parent');

zoom off

set(h_figure, 'WindowButtonMotionFcn', ...
  @(~,~) window_btn_motion_fcn(obj));

set(h_figure, 'WindowButtonUpFcn', ...
  @(~,~) window_btn_up_fcn(obj));

set(obj.h_axes, 'ButtonDownFcn', @(~,~) add_limit(obj));

h_plots = get_plots(obj.h_axes);

for i=1:length(h_plots)
  
  if get_nbr_of_samples(h_plots(i)) > 2
    
    set(h_plots(i), 'ButtonDownFcn', @(~,~) add_limit(obj));
    
  end
  
end

end