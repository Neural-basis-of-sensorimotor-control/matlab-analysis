clc
clear

neurons = get_intra_neurons();
stims = get_intra_motifs();

response_min = 5e-3;
response_max = 1e-2;
remove_fraction = .1;

for i=1:length(neurons)
	fprintf('%d out of %d\n', i, length(neurons));
	
	neuron = neurons(i);
	signal = sc_load_signal(neuron, 'check_raw_data_dir', true);
	
	signal.reset_amplitudes();
	signal.update_amplitudes(neuron.tmin, neuron.tmax, neuron.psp_templates, ...
    response_min, response_max, remove_fraction, true);
	signal.sc_save(false);
end

