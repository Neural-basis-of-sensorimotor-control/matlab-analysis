function check_raw_data_dir(file)

if ~exist(file.filepath, 'file')
  new_filepath = update_raw_data_path(file.filepath);
  
  if exist(new_filepath, 'file')
    file.filepath = new_filepath;
  end
end

success = file.prompt_for_raw_data_dir();

if ~success
  error('Could not find raw data file %s', file.filepath);
end

end