function add_overlapping_spiketrains(spiketrain_1, coupled_spiketrains, ...
  max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
  min_time_span_per_sequence, overlapping_spiketrains)

spiketimes_1 = spiketrain_1.get_spiketimes();

for i=1:len(coupled_spiketrains)
  tmp_spiketrain_2 = coupled_spiketrains(i);
  spiketimes_2 = tmp_spiketrain_2.get_spiketimes();
  
  sequences = find_time_sequences(spiketimes_1, spiketimes_2, ...
    max_inactivity_time, min_nbr_of_spikes_per_sequence, min_time_span_per_sequence);
  
  if ~isempty(sequences)
    
    tmp_overlapping_spiketrains = struct('neuron1', spiketrain_1, ...
      'neuron2', tmp_spiketrain_2, 'time_sequences', sequences);
    
    add(overlapping_spiketrains, tmp_overlapping_spiketrains);
  end
end

end
    
  
  