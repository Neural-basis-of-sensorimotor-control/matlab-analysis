function val = get_all_cell_response_values(neurons, stim_tags)

val = nan(length(stim_tags), length(neurons));

for i=1:length(neurons)
	neuron = neurons(i);
	signal = sc_load_signal(neuron, 'check_raw_data_dir', true);
	
	for j=1:length(stim_tags)
		amplitude = signal.amplitudes.get('tag', stim_tags{j});
		val(j, i) = mean(amplitude.rise_automatic_detection);
	end
end


end