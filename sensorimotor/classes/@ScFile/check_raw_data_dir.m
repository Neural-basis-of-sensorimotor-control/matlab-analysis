function check_raw_data_dir(file)

if ~exist(file.filepath, 'file')
  file.filepath = update_raw_data_path(file.filepath);
end

success = file.prompt_for_raw_data_dir();

if ~success
  error('Could not find raw data file %s', file.filepath);
end

end