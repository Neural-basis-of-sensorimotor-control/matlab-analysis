function make_mds_response_separate_cells(neurons, min_height, min_epsp_nbr)

scaling_dim = 2;

stims = get_intra_motifs();

patterns = get_values(stims, @get_pattern);
unique_patterns = unique(patterns);

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons))
  
  mds_fig = incr_fig_indx();
  clf(mds_fig, 'reset')
  
  pca_fig = incr_fig_indx();
  clf(pca_fig, 'reset')
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(unique_patterns)
    
    pattern = unique_patterns{j};
    
    stim = stims(equals(patterns, pattern));
    amplitudes = get_items(signal.amplitudes.list, 'tag', stim);
    
    is_significant_response = arrayfun(@(x) intra_is_significant_response(x, min_height, min_epsp_nbr), ...
      amplitudes);
    
    amplitudes = amplitudes(is_significant_response);
    
    responses = arrayfun(@get_all_heights, amplitudes, ...
      'UniformOutput', false);
    responses = cell2mat(responses');
    responses(isnan(responses)) = 0;
    
    responses(all(~responses, 2), :) = [];
    
    d = pdist(responses);
    
    
    try
      y = cmdscale(d, scaling_dim);
    
      figure(mds_fig)
      
      sc_square_subplot(length(unique_patterns), j);
      plot_mda(y)
      
      title(sprintf('%s: %s', neuron.file_tag, pattern));
    catch
      warning('Skipping cell %d', i);
    end
  end
  
end

end


function w = get_all_heights(amplitude)

[~, w] = get_amplitude_height(amplitude, 0);

end
