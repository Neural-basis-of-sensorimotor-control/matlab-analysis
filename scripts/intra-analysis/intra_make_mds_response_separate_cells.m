function intra_make_mds_response_separate_cells(neurons, min_height, min_epsp_nbr)

scaling_dim     = 2;
stims           = get_intra_motifs();
patterns        = get_values(stims, @get_pattern);
unique_patterns = unique(patterns);

for i=1:length(neurons)
  
  sc_debug.print(mfilename, i, length(neurons));
  
  mds_fig = incr_fig_indx();
  clf(mds_fig, 'reset')
  sc_counter.add_counter([], 0);
  
  %   pca_fig = incr_fig_indx();
  %   clf(pca_fig, 'reset')
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(unique_patterns)
    
    pattern    = unique_patterns{j};
    stim       = stims(equals(patterns, pattern));
    amplitudes = get_items(signal.amplitudes.list, 'tag', stim);
    
    is_significant_response = arrayfun(@(x) intra_is_significant_response(x, min_height, min_epsp_nbr), ...
      amplitudes);
    
    amplitudes = amplitudes(is_significant_response);
    
    responses = arrayfun(@get_all_heights, amplitudes, ...
      'UniformOutput', false);
    
    responses = cell2mat(responses');
    responses(isnan(responses)) = 0;
    
    responses(all(~responses, 2), :) = [];
    
    figure(mds_fig)
    
    if ~strcmpi(sc_debug.get_mode(), 'exceptional')
      
      sc_square_subplot(length(unique_patterns), j);
      title(sprintf('%s: %s N = %d', neuron.file_tag, pattern, ...
        length(amplitudes)));
    
    else
      
      nbr_of_responses = sum(~(~responses));
      
      [~, ind] = sort(nbr_of_responses);
      responses = responses(:, ind(2:end));
      responses(any(~responses, 2), :) = [];
      
      if size(responses, 1) >= 10
      %if ~isempty(responses)
        
        sc_square_subplot(max([sc_counter.get_count([]) 20]), sc_counter.increment([]));
        title(sprintf('%s: %s N = %d - 1', neuron.file_tag, pattern, ...
          length(amplitudes)));
      
      else
        
        continue
      
      end
      
    end
    
    
    if length(amplitudes) <= 1
      
      continue
      
    elseif length(amplitudes) <= 2
      
      y = responses;
      
    else
      
      d = pdist(responses);
      
      try
        y = cmdscale(d, scaling_dim);
      catch
        warning('Skipping cell %d', i);
      end
      
    end
    
    plot_mda(y)
    
  end
  
end

end


function w = get_all_heights(amplitude)

[~, w] = get_amplitude_height(amplitude, 0);

end
