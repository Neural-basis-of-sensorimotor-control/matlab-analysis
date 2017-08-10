function clear_sc_settings(domain_tag)

if ~nargin
  domain_tag = get_current_settings_tag();
end

raw_data_dir         = '';
intra_experiment_dir = '';
last_experiment      = '';

data = xml2struct(get_sc_settings_filename());

data.sc_settings.(domain_tag).raw_data_dir.Text         = raw_data_dir;
data.sc_settings.(domain_tag).intra_experiment_dir.Text = intra_experiment_dir;
data.sc_settings.(domain_tag).last_experiment.Text      = last_experiment;

struct2xml(data, get_sc_settings_filename());

end