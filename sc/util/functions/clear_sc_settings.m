function clear_sc_settings()

global RAW_DATA_DIR INTRA_EXPERIMENT_DIR LAST_EXPERIMENT

RAW_DATA_DIR         = '';
INTRA_EXPERIMENT_DIR = '';
LAST_EXPERIMENT      = '';

data = [];


data.sc_settings.raw_data_dir.Text         = RAW_DATA_DIR;
data.sc_settings.intra_experiment_dir.Text = INTRA_EXPERIMENT_DIR;
data.sc_settings.last_experiment.Text      = LAST_EXPERIMENT;

struct2xml(data, get_sc_settings_filename());

end