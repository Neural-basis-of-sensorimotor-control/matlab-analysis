function update_all_cells(response_min, response_max, remove_fraction)

neurons = get_intra_neurons();

for i=1:length(neurons)
	neuron = neurons(i);
	
	signal = sc_load_signal(neuron, 'check_raw_data_dir', true);
	signal.update_amplitudes(response_min, response_max, remove_fraction);
		
end

end
	
	