function write_settings(property, val)

if isempty(val)
  val = '';
elseif isnumeric(val)
  val = num2str(val);
end

domain_tag = sc_settings.get_current_settings_tag();
data       = xml2struct(sc_settings.get_settings_filename());

data.settings.(domain_tag).(property).Text = val;

struct2xml(data, sc_settings.get_settings_filename());

end