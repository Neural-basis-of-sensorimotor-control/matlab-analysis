function saved = save_experiment(experiment, save_path, prompt_before_saving)

saved = false;

if isempty(save_path) || ~exist(save_path, 'file') || prompt_before_saving
  [fname, pname] = uiputfile('*_sc.mat', 'Choose file to save', save_path);
  
  if isnumeric(fname)
    return
  end
  
  save_path = fullfile(pname, fname);
end

obj = experiment; %#ok<NASGU>
save(save_path, 'obj')
saved = true;

end