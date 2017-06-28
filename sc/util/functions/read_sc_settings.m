function val = read_sc_settings(property)

filename = get_sc_settings_filename();

try
  
  s = xml2struct(filename);
  
catch
  
  warning('Could not read %s settings file', filename);
  val = '';
  return
  
end

try
  
  val = s.sc_settings.(property).Text;
  
  if isempty(val)
    val = '';
  end
  
  return
  
catch
  
  warning('Could not find property %s in %s settings file', property, ...
    filename);
  clear_sc_settings();
  val = [];
  
end

end
