function neuron = intra_select_neurons(neuron, stims_str)

%% Select only neurons with sufficient number of recorded repetitions
nbr_of_sweeps = nan(size(neuron));

for i=1:length(nbr_of_sweeps)
  
  signal = sc_load_signal(neuron(i));
  nbr_of_sweeps(i) = get_nbr_of_sweeps(get_items(signal.amplitudes.list, 'tag', stims_str));

end

neuron = neuron(nbr_of_sweeps >= 50);