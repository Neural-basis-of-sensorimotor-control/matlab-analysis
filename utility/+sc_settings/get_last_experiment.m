function [file, full_file_path] = get_last_experiment()

file = sc_settings.read_settings(sc_settings.tags.LAST_EXPERIMENT);

if nargout >= 2
  
  if isempty(file)
    full_file_path = '';
  else
    full_file_path = [sc_settings.get_default_experiment_dir() file];
  end
  
end

end