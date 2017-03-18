function paired_neurons = scan_for_paired_neurons(neurons, min_nbr_of_overlapping_neurons)

paired_neurons = [];

for i=1:length(neurons)
  
  fprintf('Scan for paired neurons: %d out of %d\n', i, length(neurons));
  
  neuron = neurons(i);
  
  tmp_paired_neurons = get_paired_neurons(neuron, min_nbr_of_overlapping_neurons);
  
  paired_neurons = concat_list(paired_neurons, tmp_paired_neurons);

end

end