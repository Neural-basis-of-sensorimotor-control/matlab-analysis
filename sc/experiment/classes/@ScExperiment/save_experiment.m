function saved = save_experiment(experiment, save_path, prompt_before_saving)

saved = false;

if prompt_before_saving
  
  if isfile(save_path)
    default_dir = save_path;
  elseif isfile([sc_settings.get_default_experiment_dir() save_path])
    default_dir = [sc_settings.get_default_experiment_dir() save_path];
  else
    default_dir = sc_settings.get_default_experiment_dir();
  end
    
  [fname, pname] = uiputfile('*_sc.mat', ['Choose file to save ' save_path], ...
    default_dir);
  
  if ~ischar(fname)
    return
  end
  
  save_path = fullfile(pname, fname);
  
else
  
  if ~isfile(save_path)
    
    tmp_filename = [sc_settings.get_default_experiment_dir() save_path];
    
    if isfile(tmp_filename)
      
      save_path = tmp_filename;
      
    else
      
      [fname, pname] = uiputfile('*_sc.mat', ['Choose file to save ' save_path], ...
        sc_settings.get_default_experiment_dir());
      
      if ~ischar(fname)
        return
      end
      
      save_path = fullfile(fname, pname);
      
    end
    
  end
end

obj = experiment;

[~, name, ext] = fileparts(save_path);
obj.save_name = [name ext];

save(save_path, 'obj')

sc_settings.set_last_experiment(save_path);

saved = true;

end