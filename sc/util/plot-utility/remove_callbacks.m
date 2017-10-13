function remove_callbacks(h_axes, delete_plots)

if ~nargin
  h_axes = gca;
end

if nargin < 2
  delete_plots = false;
end

h_figure = get(h_axes, 'Parent');

zoom(h_axes, 'off')

set(h_figure, 'WindowButtonDownFcn', [], ...
  'WindowButtonMotionFcn',      [], ...
  'WindowButtonUpFcn',          []);

set(h_axes, 'ButtonDownFcn', []);

h_plots = get_plots(h_axes);

for i=1:length(h_plots)
  
  if get_nbr_of_samples(h_plots(i))
    
    set(h_plots(i), 'ButtonDownFcn', []);
    set(h_plots(i), 'UiContextMenu', []);
  
  end
  
end

if delete_plots
  
  for i=1:length(h_plots)
    
    if get_nbr_of_samples(h_plots(i))<=3
      delete(h_plots(i));
    end
    
  end
end

end