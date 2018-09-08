function filepath = get_raw_data_file(str_file)

str_dir = sc_settings.get_raw_data_dir();

[filepath, ~, last_dir] = ...
  sc_file_loader.get_filepath(str_file, str_dir, 2);

while isempty(filepath)
  
  str_dir = uigetdir(str_dir, sprintf('Select directory for %s', str_file));
  
  [filepath, ~, last_dir] = ...
    sc_file_loader.get_filepath(str_file, str_dir, 2);
  
  if isempty(filepath)
    
    answ = questdlg(sprintf('Could not find file %s', filepath), '', ...
      'Browse', 'Abort', 'Browse');
    
    if ~strcmp(answ, 'Browse')
      return
    end
    
  end
  
end

sc_settings.write_settings(sc_settings.tags.RAW_DATA_DIR, last_dir);

end