function experiment = load_experiment(fpath)

if ~isfile(fpath)
  temp_fpath = [get_default_experiment_dir() fpath];
  
  if isfile(temp_fpath)
    fpath = temp_fpath;
  else
    [~, temp_fname, ext] = fileparts(fpath);
    temp_fpath = [get_default_experiment_dir() temp_fname ext];
    
    if isfile(temp_fpath)
      fpath = temp_fpath;
    else
      error('Could not find file %s', fpath);
    end
  end
end

d = load(fpath, 'obj');

[~, name] = fileparts(fpath);
experiment = d.obj;
experiment.save_name = name;

set_last_experiment(fpath);

end