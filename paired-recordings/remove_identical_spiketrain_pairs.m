function remove_identical_spiketrain_pairs(overlapping_spiketrains)

indx1 = 1;

while indx1<=len(overlapping_spiketrains)
  
  tmp_pair_1 = overlapping_spiketrains(indx1);
  
  indx2 = indx1 + 1;
  
  while indx2<=len(overlapping_spiketrains)
    tmp_pair_2 = overlapping_spiketrains(indx2);
    
    if ~time_sequences_are_equal(tmp_pair_1, tmp_pair_2)
      indx2 = indx2 + 1;
      continue
    end
    
    if (spiketrains_are_equal(tmp_pair_1.neuron1, tmp_pair_2.neuron1) && ...
        spiketrains_are_equal(tmp_pair_1.neuron2, tmp_pair_2.neuron2)) || ...
        (spiketrains_are_equal(tmp_pair_1.neuron1, tmp_pair_2.neuron2) && ...
        spiketrains_are_equal(tmp_pair_1.neuron2, tmp_pair_2.neuron1))
      rm(overlapping_spiketrains, indx2);
    else
      indx2 = indx2 + 1;
    end
  end
  
  indx1 = indx1 + 1;
end

end


function is_equal = time_sequences_are_equal(pair_1, pair_2)

is_equal = (size(pair_1.time_sequences, 1) == size(pair_2.time_sequences,1)) && ...
  max(abs(pair_1.time_sequences(:) - pair_2.time_sequences(:))) < 100*eps;

end

