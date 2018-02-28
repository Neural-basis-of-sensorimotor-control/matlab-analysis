function set_last_experiment(val)

[pathstr, file, ext] = fileparts(val);

sc_settings.set_default_experiment_dir(pathstr);

last_experiment = [file ext];

sc_settings.write_settings('last_experiment', last_experiment, sc_settings.get_current_settings_tag());

end