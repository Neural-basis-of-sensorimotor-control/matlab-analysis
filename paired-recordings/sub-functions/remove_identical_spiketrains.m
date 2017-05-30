function remove_identical_spiketrains(overlapping_spiketrains)

counter = 1;

while counter <= len(overlapping_spiketrains)
  is_overlapping = true;

  tmp_overlapping_spiketrain = overlapping_spiketrains(counter);
  
  if spiketrains_are_equal(tmp_overlapping_spiketrain.neurons(1), tmp_overlapping_spiketrain.neurons(2))
    rm(overlapping_spiketrains, counter);
    continue
  end
  
  [t1, t2] = get_paired_neurons_spiketimes(tmp_overlapping_spiketrain);
  
  for j=1:size(tmp_overlapping_spiketrain.time_sequences,1)
    tmin = tmp_overlapping_spiketrain.time_sequences(j, 1);
    tmax = tmp_overlapping_spiketrain.time_sequences(j, 2);
    
    tmp_t1 = t1(t1>=tmin & t1<=tmax);
    tmp_t2 = t2(t2>=tmin & t2<=tmax);
    
    if length(tmp_t1) ~= length(tmp_t2) || max(abs(tmp_t1-tmp_t2)) > 100*eps
      is_overlapping = false;
      counter = counter+1;
      break
    end
  end
  
  if is_overlapping
    rm(overlapping_spiketrains, counter);
  end
end