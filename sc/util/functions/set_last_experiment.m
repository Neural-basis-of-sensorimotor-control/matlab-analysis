function set_last_experiment(val)

global LAST_EXPERIMENT

[pathstr, file, ext] = fileparts(val);

set_default_experiment_dir(pathstr);

LAST_EXPERIMENT = [file ext];

write_sc_settings('last_experiment', LAST_EXPERIMENT);

end