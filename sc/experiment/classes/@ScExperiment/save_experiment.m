function saved = save_experiment(experiment, save_path, prompt_before_saving)

saved = false;

if prompt_before_saving
  
  default_dir = sc_file_loader.get_filepath(save_path, ...
    sc_settings.get_default_experiment_dir(), 1);
  
  if isempty(default_dir)
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
    
    tmp_filename = sc_file_loader.get_filepath(save_path, ...
      sc_settings.get_default_experiment_dir(), 1);
    
    if isfile(tmp_filename)
      
      save_path = tmp_filename;
      
    else
      
      [fname, pname] = uiputfile('*_sc.mat', ['Choose file to save ' save_path], ...
        sc_settings.get_default_experiment_dir());
      
      if ~ischar(fname)
        return
      end
      
      save_path = fullfile(pname, fname);
      
    end
    
  end
end

obj = experiment; %#ok<NASGU>
save(save_path, 'obj')

[~, str_file, str_dir] = sc_file_loader.get_filepath(save_path, '', 1);
experiment.save_name = str_file;

sc_settings.set_last_experiment(str_file);
sc_settings.set_default_experiment_dir(str_dir);

saved = true;

end