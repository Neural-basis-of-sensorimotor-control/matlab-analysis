function paired_neurons = scan_for_paired_neurons(neurons, ...
  max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
  min_time_span_per_sequence)

paired_neurons = [];

for i=1:length(neurons)
  
  fprintf('Scan for paired neurons: %d out of %d\n', i, length(neurons));
  
  neuron = neurons(i);
  
  tmp_paired_neurons = get_paired_neurons_2(neuron, max_inactivity_time, ...
    min_nbr_of_spikes_per_sequence, min_time_span_per_sequence);
  
  paired_neurons = concat_list(paired_neurons, tmp_paired_neurons);
  
end

end