function set_last_experiment(val)

[pathstr, file, ext] = fileparts(val);

set_default_experiment_dir(pathstr);

last_experiment = [file ext];

write_sc_settings('last_experiment', last_experiment);

end