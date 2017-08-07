function check_raw_data_dir(file)

if ~isfile(file.filepath)
  new_filepath = update_raw_data_path(file.filepath);
  
  if isfile(new_filepath)
    file.filepath = new_filepath;
  end
end

success = file.prompt_for_raw_data_dir();

if ~success
  error('Could not find raw data file %s', file.filepath);
end

end