function write_sc_settings(property, val, domain_tag)

data = xml2struct(get_sc_settings_filename());

data.sc_settings.(domain_tag).(property).Text = val;

struct2xml(data, get_sc_settings_filename());

end