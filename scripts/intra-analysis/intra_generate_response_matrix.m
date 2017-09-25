function m = intra_generate_response_matrix(neurons, stim_str, height_limit, ...
  min_epsp_nbr)

m = false(length(stim_str), length(neurons));

for i=1:length(neurons)
  
  neuron = neurons(i);
  
  if ~isa(neuron, 'ScSignal')
    signal = sc_load_signal(neuron);
  else
    signal = neuron;
  end
    
  for j=1:length(stim_str)
    
    amplitude = signal.amplitudes.get('tag', stim_str{j});
    m(j,i) = amplitude.intra_is_significant_response(height_limit, ...
      min_epsp_nbr);
    
  end
  
end

end