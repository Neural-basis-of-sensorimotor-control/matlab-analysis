function clear_settings(domain_tag)

if ~nargin
  domain_tag = sc_settings.get_current_settings_tag();
end

raw_data_dir         = '';
intra_experiment_dir = '';
last_experiment      = '';

data = xml2struct(sc_settings.get_settings_filename());

data.settings.(domain_tag).raw_data_dir.Text         = raw_data_dir;
data.settings.(domain_tag).intra_experiment_dir.Text = intra_experiment_dir;
data.settings.(domain_tag).last_experiment.Text      = last_experiment;

struct2xml(data, sc_settings.get_settings_filename());

end