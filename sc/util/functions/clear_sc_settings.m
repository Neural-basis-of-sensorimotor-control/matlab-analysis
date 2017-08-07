function clear_sc_settings()

raw_data_dir         = '';
intra_experiment_dir = '';
last_experiment      = '';

data = [];


data.sc_settings.raw_data_dir.Text         = raw_data_dir;
data.sc_settings.intra_experiment_dir.Text = intra_experiment_dir;
data.sc_settings.last_experiment.Text      = last_experiment;

struct2xml(data, get_sc_settings_filename());

end