function all_p_values = intra_plot_inter_neuron ...
  (neurons, str_stims, height_limit, min_nbr_epsp, use_final_labels)

amplitude_heights = intra_get_values(str_stims, neurons, height_limit, ...
  min_nbr_epsp, @(x, varargin) x.get_amplitude_height(varargin{:}));

all_p_values      = [];

for i_stim=1:length(str_stims)
  
  p = zeros(length(neurons));

  indx_multcmp      = 1:length(neurons);
  indx_is_nonempty  = true(size(indx_multcmp));
  
  tmp_str_stim = str_stims{i_stim};
  enc_values   = amplitude_heights(i_stim, :);
  
  for i_neuron=1:length(enc_values)
    
    if isempty(enc_values{i_neuron})
      
      indx_is_nonempty(i_neuron) = false;
      continue;
      
    end
    
    for j_neuron=i_neuron+1:length(enc_values)
      
      if ~isempty(enc_values{j_neuron})
        
        p(i_neuron, j_neuron) = ranksum(enc_values{i_neuron}, ...
          enc_values{j_neuron});
        
      end
      
    end
    
  end
  
  p = p(indx_is_nonempty, :);
  p = p(:, indx_is_nonempty);
    
  all_p_values = concat_list(all_p_values, p(p ~= 0));
  
  incr_fig_indx
  clf
  fill_matrix(p);
  hold on
  
  [x, y] = find(p == 0);
  
  for i_neuron=1:length(x)
    
    x_ = x(i_neuron) + [-.5 -.5 .5 .5 -.5];
    y_ = y(i_neuron) + [-.5 .5 .5 -.5 -.5];
    
    fill(x_, y_, 'w');
    
  end
  
  try
    
    concat_colormaps(p, gca, .05, @autumn, @winter)
  
  catch
    
    warning('Could not make colormap');
    colormap('default');
  
   end
  
  colorbar
  
  labels = {neurons(indx_is_nonempty).file_tag};
  
  set(gca, 'XTick', 1:length(labels), 'XTickLabel', labels, ...
    'YTick', 1:length(labels), 'YTickLabel', labels, ...
    'XTickLabelRotation', 270);
  
  title(tmp_str_stim, 'Interpreter', 'None');
  axis tight
  
  if use_final_labels
    
    set(gca, 'XTickLabel', intra_file_tag_to_neuron_indx(get(gca, ...
      'XTickLabel'), neurons))
    
    set(gca, 'YTickLabel', intra_file_tag_to_neuron_indx(get(gca, ...
      'YTickLabel'), neurons))
    
    set(gca, 'YDir', 'reverse')
    set(gcf, 'Color', 'w')
    set(gca, 'Box', 'off')
    title(intra_final_stim_tag(tmp_str_stim));%, get_intra_motifs()));
    
  end
  
end

end