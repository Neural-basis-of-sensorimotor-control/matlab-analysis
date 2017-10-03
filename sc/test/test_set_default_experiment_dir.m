function test_sc_settings.set_default_experiment_dir()

sc_settings.set_default_experiment_dir('abc123');
assert(strcmp(sc_settings.get_default_experiment_dir(), ['abc123' filesep]));

sc_settings.set_default_experiment_dir('abc127');
assert(strcmp(sc_settings.get_default_experiment_dir(), ['abc127' filesep]));

sc_settings.set_default_experiment_dir('abC123');
assert(strcmp(sc_settings.get_default_experiment_dir(), ['abC123' filesep]));

sc_settings.set_default_experiment_dir('');
assert(strcmp(sc_settings.get_default_experiment_dir(), ''));

sc_settings.set_default_experiment_dir('abc123');
assert(strcmp(sc_settings.get_default_experiment_dir(), ['abc123' filesep]));

end