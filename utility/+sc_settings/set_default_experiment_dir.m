function set_default_experiment_dir(val)

sc_settings.write_settings('intra_experiment_dir', val, sc_settings.get_current_settings_tag());

end