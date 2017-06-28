function set_default_experiment_dir(val)

global INTRA_EXPERIMENT_DIR

INTRA_EXPERIMENT_DIR = val;

write_sc_settings('intra_experiment_dir', INTRA_EXPERIMENT_DIR);

end