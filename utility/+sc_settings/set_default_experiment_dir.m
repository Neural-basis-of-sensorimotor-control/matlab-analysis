function set_default_experiment_dir(val)

if ~nargin
  
  val = uigetdir(sc_settings.get_default_experiment_dir(), ...
    'Select default experiment directory');
  
  if ~ischar(val)
    return
  end
  
end

if isunix && ~startsWith(val, '/')
  val = ['/' val];
end

sc_settings.write_settings(sc_settings.tags.EXPERIMENT_DIR, val);

end