function print_automatic_psp_detection
clc
%clear
neuron_indx = [12 13];
neurons = get_intra_neurons(neuron_indx);
stims = get_intra_motifs();

fprintf('\tAvg spont\t\t');

for i=1:length(stims)
	fprintf('%s\t', stims{i});
end

fprintf('\n');

for i=1:length(neurons)
	%fprintf('%d out of %d\n', i, length(neurons))
	
	[signal, spont_activity] = automatic_psp_detection(neuron_indx(i));%sc_load_signal(neurons(i));
	
	amplitudes = signal.amplitudes;
	
	fprintf('%s\t', signal.parent.tag);
	fprintf('%g\n', spont_activity);
	
	fprintf('\tAutomatic\t\t');
	for j=1:length(stims)
		amplitude = amplitudes.get('tag', stims{j});
		
		nbr_of_stims = length(amplitude.automatic_xpsp_detected);
		nbr_of_automatic = nnz(amplitude.automatic_xpsp_detected);
		
		fprintf('%.2f\t', nbr_of_automatic/nbr_of_stims);
	end
	fprintf('\n')
	
	fprintf('\tManual\t\t');
	for j=1:length(stims)
		amplitude = amplitudes.get('tag', stims{j});
		
		nbr_of_stims = length(amplitude.automatic_xpsp_detected);
		nbr_of_manual = nnz(amplitude.valid_data);
		
		fprintf('%.2f\t', nbr_of_manual/nbr_of_stims);
	end
	fprintf('\n');
	
	fprintf('\tBoth\t\t');
	for j=1:length(stims)
		amplitude = amplitudes.get('tag', stims{j});
		
		nbr_of_stims = length(amplitude.automatic_xpsp_detected);
		nbr_of_both = nnz(amplitude.valid_data & amplitude.automatic_xpsp_detected);
		
		fprintf('%.2f\t', nbr_of_both/nbr_of_stims);
	end
	fprintf('\n');
	
	fprintf('\tOnly automatic\t\t');
	for j=1:length(stims)
		amplitude = amplitudes.get('tag', stims{j});
		
		nbr_of_stims = length(amplitude.automatic_xpsp_detected);
		nbr_of_only_automatic = nnz(~amplitude.valid_data & amplitude.automatic_xpsp_detected);
		
		fprintf('%.2f\t', nbr_of_only_automatic/nbr_of_stims);
	end
	fprintf('\n');
	
	fprintf('\tOnly manual\t\t');
	for j=1:length(stims)
		amplitude = amplitudes.get('tag', stims{j});
		
		nbr_of_stims = length(amplitude.automatic_xpsp_detected);
		nbr_of_only_manual = nnz(amplitude.valid_data & ~amplitude.automatic_xpsp_detected);
		
		fprintf('%.2f\t', nbr_of_only_manual/nbr_of_stims);
	end
	fprintf('\n');
	
	fprintf('\tNone\t\t');
	for j=1:length(stims)
		amplitude = amplitudes.get('tag', stims{j});
		
		nbr_of_stims = length(amplitude.automatic_xpsp_detected);
		nbr_of_none = nnz(~amplitude.valid_data & ~amplitude.automatic_xpsp_detected);
		
		fprintf('%.2f\t', nbr_of_none/nbr_of_stims);
	end
	fprintf('\n');
	fprintf('\n');
	
end
