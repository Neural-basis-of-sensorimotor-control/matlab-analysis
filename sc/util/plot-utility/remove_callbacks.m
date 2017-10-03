function remove_callbacks(h_axes)

if ~nargin
  h_axes = gca;
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
  end
  
end

end