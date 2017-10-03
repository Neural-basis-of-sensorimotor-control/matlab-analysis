function write_settings(property, val, domain_tag)

data = xml2struct(sc_settings.get_settings_filename());

data.settings.(domain_tag).(property).Text = val;

struct2xml(data, sc_settings.get_settings_filename());

end