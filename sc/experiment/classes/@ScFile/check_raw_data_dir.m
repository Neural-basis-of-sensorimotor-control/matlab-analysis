function check_raw_data_dir(file)

if ~is_file(file.filepath)
  new_filepath = update_raw_data_path(file.filepath);
  
  if is_file(new_filepath)
    file.filepath = new_filepath;
  end
  
end

success = file.prompt_for_raw_data_dir();

if ~success
  error('Could not find raw data file %s', file.filepath);
end

end