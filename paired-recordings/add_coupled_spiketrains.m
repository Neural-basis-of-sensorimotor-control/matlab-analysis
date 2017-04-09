function add_coupled_spiketrains(spiketrains, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_time_span_per_sequence, ...
  overlapping_spiketrains)

for i=1:len(spiketrains)
  fprintf('add_coupleds_spiketrains\t%d\t(%d)\n', i, len(spiketrains));

  tmp_spiketrain = spiketrains(i);
  
  tmp_coupled_spiketrains = List(spiketrains(i+1:len(spiketrains)));
  subset(tmp_coupled_spiketrains, 'file_tag', tmp_spiketrain.file_tag); 
  subset(tmp_coupled_spiketrains, 'signal_tag', tmp_spiketrain.signal_tag);
  
  add_overlapping_spiketrains(tmp_spiketrain, tmp_coupled_spiketrains, ...
     max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
     min_time_span_per_sequence, overlapping_spiketrains);
end

end