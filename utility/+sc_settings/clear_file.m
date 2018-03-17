function clear_file()

data = [];

data.settings.(sc_settings.get_default_settings_tag()).raw_data_dir = '';

struct2xml(data, sc_settings.get_settings_filename());

sc_settings.clear_settings(sc_settings.get_default_settings_tag());
sc_settings.clear_settings(sc_settings.get_test_settings_tag());

end