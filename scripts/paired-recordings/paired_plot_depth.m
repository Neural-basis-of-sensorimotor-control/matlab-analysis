function paired_plot_depth(neuron, create_figures, h_figures)
% paired_plot_depth(neuron)
 
if nargin < 2
  create_figures = true;
end

if nargin < 3
  h_figures = [];
end

str_properties = ScPairedSpThPoints.get_properties([2 6 9]);

if create_figures
     
  for i_neuron_pair_indx=1:length(str_properties)
    
    h_fig     = incr_fig_indx();
    h_figures = add_to_list(h_figures, h_fig);
    clf
    str_title = str_properties{i_neuron_pair_indx};
    str_title = str_title(6:end);
    
    h_axes = subplot(3, 3, 1);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': onset'], 'Interpreter', 'None')
    xlabel('Time [s]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 2);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': height'], 'Interpreter', 'None')
    xlabel('Frequency [Hz]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 3);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': leading flank width'], 'Interpreter', 'None')
    xlabel('Time [s]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 4);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': leading flank height'], 'Interpreter', 'None')
    xlabel('Frequency [Hz]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 5);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': trailing flank width'], 'Interpreter', 'None')
    xlabel('Time [s]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 6);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': trailing flank height'], 'Interpreter', 'None')
    xlabel('Frequency [Hz]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 7);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': peak position'], 'Interpreter', 'None')
    xlabel('Time [s]')
    ylabel('Subcortical depth (mm)')
    grid on
    
    h_axes = subplot(3, 3, 8);
    set(h_axes, 'Parent', h_fig);
    hold(h_axes, 'on')
    title(h_axes, [str_title ': normalized height'], 'Interpreter', 'None')
    xlabel('Normalized frequency')
    ylabel('Subcortical depth (mm)')
    grid on
    
  end
  
end

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_plot_depth, neuron, false, h_figures);
  %add_legend(h_figures, true);
  
  return
  
end

depths = paired_parse_for_subcortical_depth(neuron);

if strcmp(neuron.protocol_signal_tag, 'patch') || strcmp(neuron.protocol_signal_tag, 'patch1')
  depth = depths.depth1;
elseif strcmp(neuron.protocol_signal_tag, 'patch2')
  depth = depths.depth2;
else
  error('Unknown tag: %s', neuron.protocol_signal_tag);
end

for i_neuron_pair_indx=1:2
  
  tag = neuron.file_tag;%[neuron.file_tag ' - ' neuron.template_tag{i_neuron_pair_indx}];
    
  for i_property=1:length(str_properties)
    
    figure(h_figures(i_property))
    
    [onset, height, leading_flank_width, leading_flank_height, ...
      trailing_flank_width, trailing_flank_height, peak_position, ...
      normalized_height] = ...
      neuron.compute_all_distances(str_properties{i_property}, i_neuron_pair_indx);
    
    if isempty(onset)
      continue
    end
    
    subplot(3, 3, 1)
    plot(onset, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 2)
    plot(height, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 3)
    plot(leading_flank_width, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 4)
    plot(leading_flank_height, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 5)
    plot(trailing_flank_width, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 6)
    plot(trailing_flank_height, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 7)
    plot(peak_position, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
    subplot(3, 3, 8)
    plot(normalized_height, -depth, 'Marker', '+', 'MarkerSize', 12, 'LineWidth', 2, ...
      'Tag', tag)
    
  end
  
end

if length(neuron) == 1 && create_figures
  add_legend(h_figures, true);
end

end
