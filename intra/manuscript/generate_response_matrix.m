function m = generate_response_matrix(neurons, stim_str)

m = false(length(stim_str), length(neurons));

for i=1:length(neurons)
  
  neuron = neurons(i);
  
  if ~isa(neuron, 'ScSignal')
    signal = sc_load_signal(neuron);
  else
    signal = neuron;
  end
  
  threshold = get_activity_threshold(signal);
  
  for j=1:length(stim_str)
    
    amplitude = signal.amplitudes.get('tag', stim_str{j});
    m(j,i) = amplitude.userdata.fraction_detected >= threshold;
  
  end
end