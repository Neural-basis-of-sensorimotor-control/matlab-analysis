function test_clear_sc_settings()

clear_sc_settings();

assert(strcmp(get_default_experiment_dir(), ''));
assert(strcmp(get_raw_data_dir(), ''));
assert(strcmp(get_last_experiment(), ''));

disp(['Passed ' mfilename]);

end