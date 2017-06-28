function m = generate_response_value_matrix(neurons, stim_str, property)

m = nan(length(stim_str), length(neurons));

for i=1:length(neurons)
  fprintf('\t%d (%d)\n', i, length(neurons));
  
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
  for j=1:length(stim_str)
    
    amplitude = signal.amplitudes.get('tag', stim_str{j});
    
    if ischar(property)
      m(j,i) = mean(amplitude.(property));
    else
      m(j,i) = property(amplitude);
    end
  
  end
end