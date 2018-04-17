function clear_file()

data = [];

data.settings.(sc_settings.tags.DEFAULT).raw_data_dir = '';

struct2xml(data, sc_settings.get_settings_filename());

sc_settings.clear_settings(sc_settings.tags.DEFAULT);
sc_settings.clear_settings(sc_settings.tags.TEST);

end