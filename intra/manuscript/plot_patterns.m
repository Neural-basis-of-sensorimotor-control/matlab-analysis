clc
clear

scaling_dim = 2;

neurons = get_intra_neurons();
stims = get_intra_motifs();
patterns = get_values(stims, @get_pattern);
unique_patterns = unique(patterns);

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons))
  
  figure(i);
  clf reset
  at_least_one_plot = false;
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(unique_patterns)
    pattern = unique_patterns{j};
    
    stim = stims(equals(patterns, pattern));
    amplitudes = get_items(signal.amplitudes.list, 'tag', stim);
    
    nbr_of_repetitions = min(cell2mat({arrayfun(@(x) length(x.valid_data), amplitudes)}));
    valid_repetitions = true(nbr_of_repetitions, 1);
    
    for k=1:nbr_of_repetitions
      for m=1:length(amplitudes)
        
        if ~amplitudes(m).valid_data(k)
          valid_repetitions(k) = false;
          continue
        end
      end
    end
    
    valid_repetitions = find(valid_repetitions);
    
    if length(valid_repetitions)<3
      continue
    else
      at_least_one_plot = true;
    end
    
    responses = nan(length(amplitudes), length(valid_repetitions));
    for k=1:length(valid_repetitions)
      tmp_response = nan(1, length(amplitudes));
      
      for m=1:length(amplitudes)
        tmp_response(m) = amplitudes(m).data(valid_repetitions(k),4) - ...
          amplitudes(m).data(valid_repetitions(k),2);
      end
      
      responses(:,k) = tmp_response;
    end
    
    d = pdist(responses');
    y = mdscale(d, scaling_dim);
    
    sc_square_subplot(length(unique_patterns), j);
    plot_mda(y)
    title(sprintf('%s: %s', neuron.file_tag, pattern));
  end
  
  if ~at_least_one_plot
    close
    continue
  end
end