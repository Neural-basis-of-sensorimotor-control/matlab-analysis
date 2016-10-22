clc
clear

neurons = get_intra_neurons;

signal1 = sc_load_signal(neurons(1), 'check_fdir', true);

for j=2:length(neurons)
	fprintf('%d out of %d\n', j, length(neurons));
	
	signal2 = sc_load_signal(neurons(j), 'check_fdir', true);
	
	for i=1:signal1.waveforms.n
		mergefrom_waveform = signal1.waveforms.get(i);
		tag = mergefrom_waveform.tag;
		
		if ~startswithi(tag, 'EPSP')
			continue
		end
		
		
		while signal2.waveforms.has('tag', tag)
			tag = [tag '*']; %#ok<AGROW>
		end
		
		mergeto_waveform = ScWaveform(signal2, tag, []);
		for j=1:length(mergefrom_waveform.n)
			mergefrom_threshold = mergefrom_waveform.get(j);
			mergeto_waveform.add(mergefrom_threshold.create_copy());
		end
		signal2.waveforms.add(mergeto_waveform);
	end
	
	signal2.sc_save(false);
	
end

