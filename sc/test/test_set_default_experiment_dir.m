function test_set_default_experiment_dir()

set_default_experiment_dir('abc123');
assert(strcmp(get_default_experiment_dir(), 'abc123'));

set_default_experiment_dir('abc127');
assert(strcmp(get_default_experiment_dir(), 'abc127'));

set_default_experiment_dir('abC123');
assert(strcmp(get_default_experiment_dir(), 'abC123'));

set_default_experiment_dir('');
assert(strcmp(get_default_experiment_dir(), ''));

set_default_experiment_dir('abc123');
assert(strcmp(get_default_experiment_dir(), 'abc123'));

end