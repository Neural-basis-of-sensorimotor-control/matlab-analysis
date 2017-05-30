function add_spiketrains(files, spiketrains)

for i=1:len(files)
  fprintf('add_spiketrains\t%d\t(%d)\n', i, len(files));
  
  dat_file = files{i};
  
  fid = fopen(dat_file);
  header = fgetl(fid);
  fclose(fid);
  
  headers = strsplit(header, ',');
  
  is_spike = @(x) contains(x, 'spike', 'IgnoreCase', true) || ...
    contains(x, 'spikr', 'IgnoreCase', true) || ...
    contains(x, 'patch', 'IgnoreCase', true);
  
  is_spiketrain = cellfun(is_spike, headers);
  tmp_spiketrains_str = headers(is_spiketrain);
  col_indx = find(is_spiketrain);
  
  [~, name] = fileparts(dat_file);
  
  file_tag = name(1:8);
  
  for j=1:length(tmp_spiketrains_str)
    
    tmp_spiketrain_str = tmp_spiketrains_str{j};
    
    if contains(tmp_spiketrain_str, 'patch2', 'IgnoreCase', true) ...
        || contains(tmp_spiketrain_str, 'p2')
      signal_tag = 'patch2';
    else
      signal_tag = 'patch';
    end
    
    raw_data_file = dat_file;
    column_indx = col_indx(j);
    
    spiketrain = ScSpikeData('raw_data_file', raw_data_file, ...
      'column_indx', column_indx, 'signal_tag', signal_tag, ...
      'file_tag', file_tag, 'tag', tmp_spiketrain_str);
    add(spiketrains, spiketrain);
    
  end
end
