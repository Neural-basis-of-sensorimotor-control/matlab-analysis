clear

scaling_dim = 2;

neurons = get_intra_neurons();
stims = get_intra_motifs();
patterns = get_values(stims, @get_pattern);
unique_patterns = unique(patterns);

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons))
  
  incr_fig_indx();
  clf reset
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(unique_patterns)
    pattern = unique_patterns{j};
    
    stim = stims(equals(patterns, pattern));
    amplitudes = get_items(signal.amplitudes.list, 'tag', stim);
    
    nbr_of_epsps = max(arrayfun(@(x) length(x.height), amplitudes));
%     responses = arrayfun(@(x) [x.height; ones(nbr_of_epsps-length(x.height), 1)], amplitudes, ...
%       'UniformOutput', false);
    responses = arrayfun(@(x) x.data(:,4) - x.data(:,2), amplitudes, ...
      'UniformOutput', false);
    responses = cell2mat(responses');
    responses(isnan(responses)) = 0;
    
    responses(all(~responses, 2), :) = [];
    
    d = pdist(responses);
    
    try
      y = cmdscale(d, scaling_dim);
    
      sc_square_subplot(length(unique_patterns), j);
      plot_mda(y)
      title(sprintf('%s: %s', neuron.file_tag, pattern));
    catch
      warning('Skipping cell %d', i);
    end
  end
  
end