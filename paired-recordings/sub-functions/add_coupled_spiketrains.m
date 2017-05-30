function add_coupled_spiketrains(spiketrains, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_time_span_per_sequence, ...
  overlapping_spiketrains)

while len(spiketrains)>0
  fprintf('add_coupleds_spiketrains\t%d\n', len(spiketrains));
  
  tmp_spiketrain = spiketrains(1);
  rm(spiketrains, 1);
  
  tmp_similar_spiketrains = List(get_items(list(spiketrains), 'file_tag', tmp_spiketrain.file_tag));
  subset(tmp_similar_spiketrains, 'signal_tag', tmp_spiketrain.signal_tag);
  subset(tmp_similar_spiketrains, ...
    @(x) spiketrains_are_equal(tmp_spiketrain, x), false);
  
  add_overlapping_spiketrains(tmp_spiketrain, tmp_similar_spiketrains, ...
    max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
    min_time_span_per_sequence, overlapping_spiketrains);
end

end
