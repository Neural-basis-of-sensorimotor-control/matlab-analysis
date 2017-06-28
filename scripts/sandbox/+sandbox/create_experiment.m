function create_experiment(tag, raw_data_dir_base)

experiment = sandbox.Experiment(tag, base_raw_data_dir);

[raw_data_files, raw_data_path] = uigetfile({'*.mat', '*.adq'}, ...
  'Select raw data files', raw_data_dir_base, 'MultiSelect', 'on');

if ~iscell(raw_data_files)
  raw_data_files = {raw_data_files};
end

if startsWith(raw_data_path, raw_data_dir_base)
  experiment.raw_data_dir_folder = raw_data_path(length(raw_data_dir_base)+1:end);
end

for i=1:length(raw_data_files)
  
  filepath = [experiment.get_raw_data_dir() filesep raw_data_files{i}];
  
  channel = who('-file', filepath);
  
  for j=1:numel(channel)
    
    tmp_channel = channel{j};
    
    d = load(filepath, tmp_channel);
    channelvalue = d.(tmp_channel);
    
    if isfield(channelvalue, 'values')
      
      %Create waveform channel
      tmp_tag = tmp_channel;
      dt = channelvalue.interval;
      n = channelvalue.length; %<- sometimes incorrect value from Spike2
      
    elseif strcmpi(tmp_channel,'TextMark') || strcmpi(tmp_channel,'Keyboard')
      
      %Create text channel
      
    elseif isfield(channelvalue,'times')
     
      %Create trigger channel
      
    else
      msg = sprintf('Warning: Channel %s in file %s did not meet any criteria in %s.\n Go find Hannes if you think this channel should be viewable.', tmp_channel, tag, mfilename);
      msgbox(msg);
    end
  end
  
  
end