function output_depth = paired_parse_for_subcortical_depth(neuron)

if length(neuron) ~= 1
  
  output_depth = vectorize_fcn(@paired_parse_for_subcortical_depth, neuron);
  return
  
end

output_depth   = struct('depth1', [], 'depth2', []);

if ~isempty(neuron.subcortical_depth_mm)
  
  if strcmp(neuron.signal_tag, 'patch')
    
    output_depth.depth1 = neuron.subcortical_depth_mm;
    output_depth.depth2 = nan;
  
  elseif strcmp(neuron.signal_tag, 'patch2')
    
    output_depth.depth1 = nan;
    output_depth.depth2 = neuron.subcortical_depth_mm;
    
  else
    
    error('Unknown signal tag: %s\n', neuron.signal_tag);
  
  end
  
  return
  
end

file           = sc_load_file(neuron);
experiment_tag = file.tag(1:4);
file_index     = str2num(file.tag(5:8));
[~, tmp] = fileparts(file.parent.fdir);
str_files      = ls([sc_settings.get_raw_data_dir tmp]);

for tmp_file_index=file_index:100
  
  if tmp_file_index<10
    tmp_file_tag = [experiment_tag  '000' num2str(tmp_file_index)];
  else
    tmp_file_tag = [experiment_tag  '00'  num2str(tmp_file_index)];
  end
  
  for row=1:size(str_files, 1)
    
    tmp_file = strtrim(str_files(row, :));
    
    if ~isempty(regexp(tmp_file, ['\d\d \d\d \d\d ' tmp_file_tag '.txt'], 'once'))
      
      [output_depth.depth1, output_depth.depth2] = ...
        paired_extract_subcortical_depth([file.parent.fdir filesep tmp_file], ...
        neuron.file_tag, neuron.protocol_signal_tag);
      
      return
      
    end
    
  end
  
end


error('Could not parse neuron %s', neuron.file_tag)

end