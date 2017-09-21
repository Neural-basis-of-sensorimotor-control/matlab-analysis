function paired_plot_depth(neuron, create_figures, h_axes)

if nargin < 2
  create_figures = true;
end

if nargin < 3
  h_axes = [];
end

if create_figures
  
  incr_fig_indx();
  clf
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 1));
  hold on
  title('Pre-spike depression falling flank height')
  xlabel('Frequency [Hz]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 2));
  hold on
  title('Pre-spike depression falling flank width')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 3));
  hold on
  title('Pre-spike depression rising flank width')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 4));
  hold on
  title('SpTH peak rise time')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 5));
  hold on
  title('SpTH peak location')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 6));
  hold on
  title('SpTH peak fall time')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 7));
  hold on
  title('Post-spike depression')
  xlabel('Frequency [Hz]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 8));
  hold on
  title('Post-spike depression falling flank width')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
  h_axes = add_to_list(h_axes, subplot(3, 3, 9));
  hold on
  title('Post-spike depression rising flank width')
  xlabel('Time [s]')
  ylabel('Subcortical depth (mm)')
  grid on
  
%  linkaxes(h_axes)
  
end

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_plot_depth, neuron, false, h_axes);
  add_legend();
  
  return
  
end

depths = paired_parse_for_subcortical_depth(neuron);

if strcmp(neuron.protocol_signal_tag, 'patch')
  depth = depths.depth1;
elseif strcmp(neuron.protocol_signal_tag, 'patch2')
  depth = depths.depth2;
end

for i=1:2
  
  tag =  [neuron.file_tag ' - ' neuron.template_tag{1}];
  x   = neuron.x{i};
  y  = neuron.y{i};
  
  axes(h_axes(1)) %#ok<*LAXES>
  plot(y(2) - y(1), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'Tag', tag)
  
  axes(h_axes(2))
  plot(x(2) - x(1), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'Tag', tag)
  
  axes(h_axes(3))
  plot(x(3) - x(2), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'Tag', tag)
  
  axes(h_axes(4))
  plot(y(4) - y(3), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'Tag', tag)
  
  axes(h_axes(5))
  plot(x(4), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'Tag', tag)
  
  axes(h_axes(6))
  plot(y(4) - y(5), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
    'Tag', tag)
  
  if length(y) >= 6
    
    axes(h_axes(7))
    plot(y(6) - y(5), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    axes(h_axes(8))
    plot(x(6) - x(5), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
  end
  
  if length(y) >= 7
    
    axes(h_axes(9))
    plot(x(7) - x(6), -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
  end
  
end

if length(neuron) == 1 && create_figures
  add_legend();
end