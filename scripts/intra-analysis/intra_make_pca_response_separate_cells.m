function intra_make_pca_response_separate_cells(neurons, min_height, min_epsp_nbr, only_epsp)

stims = get_intra_motifs();

patterns = get_values(stims, @get_pattern);
unique_patterns = unique(patterns);
signals = sc_load_signal(neurons);

for i=1:length(signals)
  
  fprintf('%d out of %d\n', i, length(signals))
  
  pca_fig = incr_fig_indx();
  clf(pca_fig, 'reset')
  
  signal = signals(i);%sc_load_signal(neuron);
  
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
    
    if only_epsp
      responses(responses<0) = 0;
    end
    
    responses(all(~responses, 2), :) = [];
    
    if size(responses, 2) > 1
      
      [~, score, ~, ~, explained] = pca(responses);
      
      sc_square_subplot(length(unique_patterns)+1, j);
      
      plot(score(:, 1), score(:, 2), 'Marker', '.', 'LineStyle', 'none');
      
      title(sprintf('PCA %s (%d coord)', pattern, size(responses, 2)));
      
      sc_square_subplot(length(unique_patterns)+1, length(unique_patterns)+1)
      hold on
      plot(1:length(explained), cumsum(explained), 'Tag', pattern);
      
    end
    
  end
  
  h_subplot = sc_square_subplot(length(unique_patterns)+1, length(unique_patterns)+1);
  hold(h_subplot, 'on');
  add_legend(h_subplot);
  grid(h_subplot, 'on');
  ylim(h_subplot, [0 110]);
  xlabel(h_subplot, '# of PC coordinates')
  ylabel(h_subplot, 'Percentage explained');
  title(signal.parent.tag)
  
end

incr_fig_indx();
clf reset

for i=1:length(unique_patterns)
  
  pattern = unique_patterns{i};
  
  h_subplot = sc_square_subplot(length(unique_patterns), i);
  
  hold(h_subplot, 'on');
  grid(h_subplot, 'on');
  ylim(h_subplot, [0 110]);
  xlabel(h_subplot, '# of PC coordinates')
  ylabel(h_subplot, 'Percentage explained');
  title(pattern)
  
  for j=1:length(signals)
    
    signal = signals(j);
    
    stim = stims(equals(patterns, pattern));
    amplitudes = get_items(signal.amplitudes.list, 'tag', stim);
    
    is_significant_response = arrayfun(@(x) intra_is_significant_response(x, min_height, min_epsp_nbr), ...
      amplitudes);
    
    amplitudes = amplitudes(is_significant_response);
    
    responses = arrayfun(@get_all_heights, amplitudes, ...
      'UniformOutput', false);
    responses = cell2mat(responses');
    responses(isnan(responses)) = 0;
    
    if only_epsp
      responses(responses<0) = 0;
    end
    
    responses(all(~responses, 2), :) = [];
    
    [~, ~, ~, ~, explained] = pca(responses);
    
    plot(1:length(explained), cumsum(explained), 'Tag', signal.parent.tag);
    
  end
  
end

add_legend(gcf, true);

end



function w = get_all_heights(amplitude)

[~, w] = get_amplitude_height(amplitude, 0);

end
