clc
clear
close all

neurons = get_intra_neurons();
stims = get_intra_motifs();
is_response = generate_response_matrix(neurons, stims);
stims = stims(all(is_response, 2));

for i=1:length(neurons)
	
	neuron = neurons(i);
	signal = sc_load_signal(neuron);
	sc_square_subplot(length(neurons), i)
	hold on
	
	for j=1:length(stims)
		
		stim_str = stims{j};
		stim = signal.amplitudes.get('tag', stim_str);
		
		for k=1:length(stim.height)
			plot(stim.height(k), j, '.', 'Tag', neuron.file_str)
		end
	end
	title(neuron.file_str)
	set(gca, 'YTick', 1:length(stims), 'YTickLabel', stims);
end

