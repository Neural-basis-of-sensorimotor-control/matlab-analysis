function filepath = get_experiment_file(str_file)

if ~nargin
  str_file = sc_settings.get_last_experiment();
end

str_dir = sc_settings.get_default_experiment_dir();

[filepath, last_file, last_dir] = sc_file_loader.get_filepath(str_file, str_dir, 1);

while isempty(filepath)
  
  [str_file, str_dir] = uigetfile('*_sc.mat', ...
    sprintf('Select experiment file %s', str_file), str_dir);
  
  if ~ischar(str_file)
    return
  end
  
  [filepath, last_file, last_dir] = sc_file_loader.get_filepath(str_file, str_dir, 1);
  
  if isempty(filepath)
    
    answ = questdlg(sprintf('Could not find file %s', filepath), '', ...
      'Browse', 'Abort', 'Browse');
    
    if ~strcmp(answ, 'Browse')
      return
    end
    
  end
  
end

sc_settings.write_settings(sc_settings.tags.EXPERIMENT_DIR,  last_dir);
sc_settings.write_settings(sc_settings.tags.LAST_EXPERIMENT, last_file);

end