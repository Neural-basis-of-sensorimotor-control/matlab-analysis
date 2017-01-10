function experiment = load_experiment(fpath)

if ~exist(fpath, 'file')
  temp_fpath = [get_default_experiment_dir() fpath];
  
  if exist(temp_fpath, 'file')
    fpath = temp_fpath;
  else
    [~, temp_fname, ext] = fileparts(fpath);
    temp_fpath = [get_default_experiment_dir() temp_fname ext];
    
    if exist(temp_fpath, 'file')
      fpath = temp_fpath;
    else
      error('Could not find file %s', fpath);
    end
  end
end

d = load(fpath, 'obj');
experiment = d.obj;

experiment.sc_dir = fileparts(fpath);

end