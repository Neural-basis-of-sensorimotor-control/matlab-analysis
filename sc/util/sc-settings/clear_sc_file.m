function clear_sc_file()

data = [];

data.sc_settings.(get_default_settings_tag()).raw_data_dir = '';

struct2xml(data, get_sc_settings_filename());

clear_sc_settings(get_default_settings_tag());
clear_sc_settings(get_test_settings_tag());

end