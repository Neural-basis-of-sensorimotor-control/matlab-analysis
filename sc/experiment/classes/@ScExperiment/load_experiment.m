function experiment = load_experiment(full_file_path)

if ~isfile(full_file_path)
  
  temp_full_file_path = [full_file_path '.mat'];
  
  if isfile(temp_full_file_path)
    
    full_file_path = temp_full_file_path;
    
  else
    
    temp_full_file_path = [sc_settings.get_default_experiment_dir() full_file_path];
    
    if isfile(temp_full_file_path)
      
      full_file_path = temp_full_file_path;
      
    else
      
      temp_full_file_path = [sc_settings.get_default_experiment_dir() full_file_path '.mat'];
      
      if isfile(temp_full_file_path)
        
        full_file_path = temp_full_file_path;
        
      else
        
        [filename, pathname] = uigetfile(full_file_path, ...
          sprintf('Select directory for %s', full_file_path));
        
        temp_full_file_path = fullfile(pathname, filename);
        
        if isfile(temp_full_file_path)
          
          full_file_path = temp_full_file_path;
          sc_settings.set_default_experiment_dir(pathname);
          
        else
          
          error('Could not find file %s', full_file_path);
          
        end
        
      end
      
    end
    
  end
  
end

d = load(full_file_path, 'obj');

[~, name, ext] = fileparts(full_file_path);
experiment = d.obj;
experiment.save_name = [name ext];

sc_settings.set_last_experiment(full_file_path);

end