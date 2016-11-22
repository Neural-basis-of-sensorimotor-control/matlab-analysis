function saved = save_experiment(experiment, save_path, prompt_before_saving)

saved = false;

file_missing = isempty(save_path) || ~exist(save_path, 'file');

if file_missing || prompt_before_saving
  
  if file_missing
    default_dir = get_default_experiment_dir;
  else
    default_dir = save_path;
  end
  
  [fname, pname] = uiputfile('*_sc.mat', ['Choose file to save ' save_path], ...
    default_dir);
  
  if isnumeric(fname)
    return
  end
  
  save_path = fullfile(pname, fname);
end

[folder, file, extension] = fileparts(save_path);
experiment.sc_dir = folder;
experiment.save_name = [file extension];

obj = experiment; %#ok<NASGU>
save(save_path, 'obj')
saved = true;

end