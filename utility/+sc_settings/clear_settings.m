function clear_settings(domain_tag)

if ~nargin
  domain_tag = sc_settings.get_current_settings_tag();
end

raw_data_dir         = '';
intra_experiment_dir = '';
last_experiment      = '';

data = xml2struct(sc_settings.get_settings_filename());

data.settings.(domain_tag).(sc_settings.tags.RAW_DATA_DIR).Text    = raw_data_dir;
data.settings.(domain_tag).(sc_settings.tags.EXPERIMENT_DIR).Text  = intra_experiment_dir;
data.settings.(domain_tag).(sc_settings.tags.LAST_EXPERIMENT).Text = last_experiment;

struct2xml(data, sc_settings.get_settings_filename());

end