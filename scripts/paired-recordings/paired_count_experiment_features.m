clear
close all
sc_settings.set_current_settings_tag(sc_settings.get_default_settings_tag())

reset_fig_indx()
paired_load_constants
paired_load_settings

[unique_vals, counts] = count_items_in_list(ec_neurons, 'file_tag');
[unique_n, n_counts]  = count_items_in_list(counts);

result = struct();

result.prespike_onset                 = [];
result.prespike_trailing_flank_width  = [];
result.prespike_peak_position         = [];
result.prespike_normalized_height     = [];

result.perispike_onset                = [];
result.perispike_trailing_flank_width = [];
result.perispike_peak_position        = [];
result.perispike_normalized_height    = [];

result.postspike_onset                = [];
result.postspike_trailing_flank_width = [];
result.postspike_peak_position        = [];
result.postspike_normalized_height    = [];

subcortical_layer              = {};

for i_neuron_pair=1:length(ec_neurons)
  
  sc_debug.print(i_neuron_pair, length(ec_neurons));
  
  tmp_paired_neuron = ec_neurons(i_neuron_pair);
  
  str_layer = paired_get_layer(tmp_paired_neuron);
  
  subcortical_layer = concat_list(subcortical_layer, ...
    cellfun(@(x) str_layer, cell(2, 1), 'UniformOutput', false));
  
  for i_neuron=1:2
    
    [tmp_prespike_onset, ~, ~, ~, tmp_prespike_trailing_flank_width, ~, tmp_prespike_peak_position, tmp_prespike_normalized_height] ...
      = tmp_paired_neuron.compute_all_distances('indx_prespike_response', i_neuron);
    
    result.prespike_onset                = add_to_list(result.prespike_onset, tmp_prespike_onset);
    result.prespike_trailing_flank_width = add_to_list(result.prespike_trailing_flank_width, tmp_prespike_trailing_flank_width);
    result.prespike_peak_position        = add_to_list(result.prespike_peak_position, tmp_prespike_peak_position);
    result.prespike_normalized_height    = add_to_list(result.prespike_normalized_height, tmp_prespike_normalized_height);
    
    [tmp_perispike_onset, ~, ~, ~, tmp_perispike_trailing_flank_width, ~, tmp_perispike_peak_position, tmp_perispike_normalized_height] ...
      = tmp_paired_neuron.compute_all_distances('indx_perispike_response', i_neuron);
    
    result.perispike_onset                = add_to_list(result.perispike_onset, tmp_perispike_onset);
    result.perispike_trailing_flank_width = add_to_list(result.perispike_trailing_flank_width, tmp_perispike_trailing_flank_width);
    result.perispike_peak_position        = add_to_list(result.perispike_peak_position, tmp_perispike_peak_position);
    result.perispike_normalized_height    = add_to_list(result.perispike_normalized_height, tmp_perispike_normalized_height);
    
    [tmp_postspike_onset, ~, ~, ~, tmp_postspike_trailing_flank_width, ~, tmp_postspike_peak_position, tmp_postspike_normalized_height] ...
      = tmp_paired_neuron.compute_all_distances('indx_postspike_response', i_neuron);
    
    result.postspike_onset                = add_to_list(result.postspike_onset, tmp_postspike_onset);
    result.postspike_trailing_flank_width = add_to_list(result.postspike_trailing_flank_width, tmp_postspike_trailing_flank_width);
    result.postspike_peak_position        = add_to_list(result.postspike_peak_position, tmp_postspike_peak_position);
    result.postspike_normalized_height    = add_to_list(result.postspike_normalized_height, tmp_postspike_normalized_height);
    
  end
  
end

[~, layer_enumeration] = paired_get_layer();
is_layer_III           = cellfun(@(x) strcmp(x, layer_enumeration{1}), subcortical_layer);

fields = fieldnames(result);

f0 = incr_fig_indx();
clf

f1 = incr_fig_indx();
clf

f2 = incr_fig_indx();
clf

for i=1:length(fields)
  
  fn = incr_fig_indx();
  clf
  
  str_field = fields{i};
  
  x                 = result.(str_field);
  %%%%%x                 = result.postspike_trailing_flank_width + result.postspike_peak_position - result.postspike_onset;
  b_nonzero         = x ~= 0;
  x_nnz             = x(b_nonzero);
  ec_neurons_double = sc_unpack_cell(arrayfun(@(x) {x; x}, ec_neurons, 'UniformOutput', false));
  ec_neurons_double_nnz = ec_neurons_double(b_nonzero);
  
  p_layer = ranksum(x(is_layer_III & b_nonzero), x(~is_layer_III & b_nonzero));
  
  indx_complete_pairs = find(sum(b_nonzero(bsxfun(@plus, [1 2], repmat(2*((1:(length(b_nonzero)/2))-1)', 1, 2))), 2) == 2);
  indx_complete_pairs = 2*(indx_complete_pairs) + [-1 0];
  indx_complete_pairs = indx_complete_pairs(:);
  x_pair_nnz          = x(indx_complete_pairs);
  
  intra_pair_diff     = abs(x_pair_nnz(1:2:end) - x_pair_nnz(2:2:end));
  x_pair_nnz_shuffled = x_pair_nnz(randperm(length(x_pair_nnz)));
  inter_pair_diff     = abs(x_pair_nnz_shuffled(1:2:end) - x_pair_nnz_shuffled(2:2:end));
  
  p_intra_pair_diff   = ranksum(intra_pair_diff, inter_pair_diff);
  
  
  figure(fn)
  hold on
  grid on
  
  
  for j=1:length(x_nnz)
    y = find(arrayfun(@(x) x == ec_neurons_double_nnz{j}, ec_neurons));
    plot(x_nnz(j), y, 'Marker', '+')
  end
  
  set(gca, 'YTick', 1:length(ec_neurons), 'YTickLabel', {ec_neurons.file_tag});
  
  title(str_field, 'InterPreter', 'none');
  
  figure(f0)
  sc_square_subplot(length(fields), i)
  hold on
  grid on
  plot(intra_pair_diff, ones(size(intra_pair_diff)), '+')
  plot(inter_pair_diff, 2*ones(size(intra_pair_diff)), '+')
  ylim([0 3])
  title(str_field, 'InterPreter', 'none');
  
  figure(f1)
  sc_square_subplot(length(fields), i)
  hold on
  grid on
  title(str_field)
  
  for j=1:2:length(x_pair_nnz)
    
    x_ = min(x_pair_nnz(j + [0 1]));
    y_ = max(x_pair_nnz(j + [0 1]));
    plot(x_, y_, '+', 'Tag', 'paired')
    
  end
  
  for j=1:2:length(x_pair_nnz_shuffled)
    
    x_ = min(x_pair_nnz_shuffled(j + [0 1]));
    y_ = max(x_pair_nnz_shuffled(j + [0 1]));
    plot(x_, y_, 's', 'Tag', 'shuffled')
    
  end
  
  if all(x_pair_nnz >= 0)
    
    xl = xlim;
    xlim([0 xl(2)])
    yl = ylim;
    ylim([0 yl(2)])
    
  elseif all(x_pair_nnz <= 0)
    
    xl = xlim;
    xlim([xl(1) 0])
    yl = ylim;
    ylim([yl(1) 0])
    
  end
  
  plot(xlim, xlim)
  
  if all(x_nnz >= 0) || all(x_nnz <= 0)
    figure(f2)
    sc_square_subplot(length(fields), i)
    hold on
    grid on
    title(str_field)
    
    for j=1:2:length(x_pair_nnz)
      
      x_ = min(x_pair_nnz(j + [0 1]));
      y_ = max(x_pair_nnz(j + [0 1]));
      plot(1, y_-x_, '+', 'Tag', 'paired')
      
    end
    
    for j=1:2:length(x_pair_nnz_shuffled)
      
      x_ = min(x_pair_nnz_shuffled(j + [0 1]));
      y_ = max(x_pair_nnz_shuffled(j + [0 1]));
      plot(2, y_-x_, 's', 'Tag', 'shuffled')
      
    end
    
    xlim([0 3])
    
  end
  
  if median(intra_pair_diff) > median(inter_pair_diff)
    tmp = '-';
  else
    tmp = '+';
  end
  
  fprintf('%-30s\t%2d\t%10f\t%10f\t', fields{i}, nnz(b_nonzero), ...
    median(intra_pair_diff), median(inter_pair_diff));
  
  if all(x_nnz >= 0) || all(x_nnz <= 0)
    
    fprintf('%s\t%10f\t%10f\t%10f\t+/-\t%-10f\t%10f', tmp, p_layer, p_intra_pair_diff, ...
      mean(x_nnz), std(x_nnz), 100*std(x_nnz)/abs(mean(x_nnz)));
    
  end
  
  fprintf('\n');
  
end

add_legend(f1, true);
add_legend(f2);







