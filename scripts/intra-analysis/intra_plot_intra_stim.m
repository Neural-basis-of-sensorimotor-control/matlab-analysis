function all_p_values = intra_plot_intra_stim(neurons, str_stims, ...
  height_limit, min_nbr_epsp, use_final_labels)

amplitude_heights = intra_get_values(str_stims, neurons, height_limit, min_nbr_epsp, @(x, varargin) x.get_amplitude_height(varargin{:}));
all_p_values      = [];

for i_neuron=1:length(neurons)
  
  multcmp_indx      = 1:length(str_stims);
  indx_is_nonempty  = true(size(multcmp_indx));
  
  enc_values   = amplitude_heights(:, i_neuron);
  
  values = [];
  tags   = {};
  
  for i=1:length(enc_values)
    
    tmp_values = enc_values{i};
    
    if isempty(tmp_values)
      
      indx_is_nonempty(i) = false;
      
    else
      
      values = concat_list(values, tmp_values);
      tags   = concat_list(tags, ...
        arrayfun(@(~) str_stims{i}, ones(size(tmp_values)), ...
        'UniformOutput', false));
      
    end
    
  end
  
  [~, ~, stats] = kruskalwallis(values, tags);
  c             = multcompare(stats);
  
  multcmp_indx = multcmp_indx(indx_is_nonempty);
  rows         = c(:, 1);
  cols         = c(:, 2);
  tmp_values   = c(:, 6);
  
  tmp_stims = str_stims(indx_is_nonempty);
  
  for i=length(multcmp_indx):-1:1
    
    rows(rows == i) = multcmp_indx(i);
    cols(cols == i) = multcmp_indx(i);
    
  end
  
  p = zeros(length(str_stims));
 
  indx = sub2ind(size(p), rows, cols);
  
  p(indx) = tmp_values;
  p = p(any(p, 1), any(p, 2));
  
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
  set(gca, 'XTick', 1:length(tmp_stims), 'XTickLabel', tmp_stims, 'YDir', 'reverse', ...
    'YTick', 1:length(tmp_stims), 'YTickLabel', tmp_stims, 'XTickLabelRotation', 270);
  title(neurons(i_neuron).file_tag, 'Interpreter', 'None');
  axis tight
  
  if use_final_labels
    
    set(gca, 'XTickLabel', intra_stim_tag_to_indx(get(gca, 'XTickLabel'), str_stims))
    set(gca, 'YTickLabel',  intra_stim_tag_to_indx(get(gca, 'YTickLabel'), str_stims))
    set(gca, 'YDir', 'reverse')
    set(gcf, 'Color', 'w')
    set(gca, 'Box', 'off')
    title(intra_file_tag_to_neuron_indx(i_neuron, neurons));
    
  end
  
end

end


