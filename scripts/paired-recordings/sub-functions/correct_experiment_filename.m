function correct_experiment_filename(overlapping_spiketrains)

for i=1:len(overlapping_spiketrains)
  tmp_pair = overlapping_spiketrains(i);
  
  for j=1:length(tmp_pair.neurons)
    
    if strcmp(tmp_pair.neurons(j).file_tag, 'NR_CENR0')
      tmp_pair.neurons(j).file_tag = 'CENR0001';
      
    end
    
  end
end