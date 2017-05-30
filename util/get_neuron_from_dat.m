function neuron = get_neuron_from_dat(raw_data_file)

if iscell(raw_data_file)
  
  neuron(10*length(raw_data_file), 1) = ScSpikeData;
  counter = 0;
  
  for i=1:length(raw_data_file)
    
    tmp_neuron = get_neuron_from_dat(raw_data_file{i});
    neuron(counter + (1:length(tmp_neuron))) = tmp_neuron;
    counter = counter + length(tmp_neuron);
    
  end
  
  neuron = neuron(1:counter);
  
else
  
  neuron(10, 1) = ScSpikeData;
  counter = 0;
  
  fid = fopen(raw_data_file);
  header = fgetl(fid);
  fclose(fid);
  
  headers = strsplit(header, ',');
  
  is_spike = @(x) contains(x, 'spike', 'IgnoreCase', true) || ...
    contains(x, 'spikr', 'IgnoreCase', true) || ...
    contains(x, 'patch', 'IgnoreCase', true);
  
  is_spiketrain = cellfun(is_spike, headers);
  tmp_spiketrains_str = headers(is_spiketrain);
  col_indx = find(is_spiketrain);
  
  [~, name] = fileparts(raw_data_file);
  
  if startsWith(name, 'NR_CENR')
    file_tag = name(4:11);
  else
    file_tag = name(1:8);
  end
  
  for i=1:length(tmp_spiketrains_str)
    
    tmp_spiketrain_str = tmp_spiketrains_str{i};
    
    if contains(tmp_spiketrain_str, 'patch2', 'IgnoreCase', true) ...
        || contains(tmp_spiketrain_str, 'p2')
      signal_tag = 'patch2';
    else
      signal_tag = 'patch';
    end
    
    column_indx = col_indx(i);
    
    counter = counter + 1;
    neuron(counter) = ScSpikeData('raw_data_file', raw_data_file, ...
      'column_indx', column_indx, 'signal_tag', signal_tag, ...
      'file_tag', file_tag, 'tag', tmp_spiketrain_str);
    
  end
  
  neuron = neuron(1:counter);
  
end

end