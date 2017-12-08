function all_p_values = intra_plot_inter_neuron ...
  (neurons, str_stims, height_limit, min_nbr_epsp, use_final_labels)

amplitude_heights = intra_get_values(str_stims, neurons, height_limit, min_nbr_epsp, @(x, varargin) x.get_amplitude_height(varargin{:}));
all_p_values      = [];

for i_stim=1:length(str_stims)
  
  indx_multcmp      = 1:length(neurons);
  indx_is_nonempty  = true(size(indx_multcmp));
  
  tmp_str_stim = str_stims{i_stim};
  enc_values   = amplitude_heights(i_stim, :);
  
  values = [];
  tags   = {};
  
  for i=1:length(enc_values)
    
    tmp_values = enc_values{i};
    
    if isempty(tmp_values)
      
      indx_is_nonempty(i) = false;
      
    else
      
      values = concat_list(values, tmp_values);
      tags   = concat_list(tags, ...
        arrayfun(@(~) neurons(i).file_tag, ones(size(tmp_values)), ...
        'UniformOutput', false));
      
    end
    
  end
  
  [~, ~, stats] = kruskalwallis(values, tags, 'off');
  c             = multcompare(stats);
  
  indx_multcmp = indx_multcmp(indx_is_nonempty);
  rows         = c(:, 1);
  cols         = c(:, 2);
  tmp_values   = c(:, 6);
  
  for i=length(indx_multcmp):-1:1
    
    rows(rows == i) = indx_multcmp(i);
    cols(cols == i) = indx_multcmp(i);
    
  end
  
  p = zeros(length(neurons));
  
  indx = sub2ind(size(p), rows, cols);
  
  p(indx) = tmp_values;
  p       = p(any(p, 1), any(p, 2));

  
  all_p_values = concat_list(all_p_values, p(p ~= 0));
  
  incr_fig_indx
  clf
  fill_matrix(p);
  hold on
  
  [x, y] = find(p == 0);
  
  for i=1:length(x)
    
    x_ = x(i) + [-.5 -.5 .5 .5 -.5];
    y_ = y(i) + [-.5 .5 .5 -.5 -.5];
    fill(x_, y_, 'w');
    
  end
  
  try
    concat_colormaps(p, gca, .05, @autumn, @winter)
  catch
    warning('Could not make colormap');
    colormap('default');
  end
  
  colorbar
  set(gca, 'XTick', 1:length(neurons), 'XTickLabel', {neurons.file_tag}, ...
    'YTick', 1:length(neurons), 'YTickLabel', {neurons.file_tag}, 'XTickLabelRotation', 270);
  title(tmp_str_stim, 'Interpreter', 'None');
  axis tight
  
  if use_final_labels
    
    set(gca, 'XTickLabel', intra_file_tag_to_neuron_indx(get(gca, 'XTickLabel'), neurons))
    set(gca, 'YTickLabel', intra_file_tag_to_neuron_indx(get(gca, 'YTickLabel'), neurons))
    set(gca, 'YDir', 'reverse')
    set(gcf, 'Color', 'w')
    set(gca, 'Box', 'off')
    title(intra_stim_tag_to_indx(tmp_str_stim, get_intra_motifs()));
    
  end
  
end

end