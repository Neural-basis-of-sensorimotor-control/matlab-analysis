function val = read_settings(property)

val        = '';

filename   = sc_settings.get_settings_filename();
domain_tag = sc_settings.get_current_settings_tag();

if isfile(filename)
  
  try
    
    s = xml2struct(filename);
    
  catch
    
    sc_settings.clear_file();
    warning('Settings file %s appears to be corrupt. Clearing file.', filename);
    return
    
  end
  
  if ~isfield(s, 'settings')
    
    sc_settings.clear_file();
    warning('Settings file %s appears to be corrupt. Clearing file.', filename);
    return

  end
    
  if isfield(s.settings, domain_tag)
    
    if isfield(s.settings.(domain_tag), property)
      
      try
        
        val = s.settings.(domain_tag).(property).Text;
        
        if isempty(val)
          val = '';
        end
        
      catch
        
        warning('Could not find property %s using settings %s in %s file. Setting empty value.', ...
          property, domain_tag, filename);
        
        sc_settings.write_settings(property, '');
        
      end
      
    else
      
      warning('Could not find property %s. Setting empty value.', property);
      sc_settings.write_settings(property, '');
    
    end
    
  else
    
    warning('Could not find settings domain %s. Setting empty values.', domain_tag);
    sc_settings.clear_settings(domain_tag);
    
  end
  
else
  
  warning('Could not find %s settings file. Creating new', filename);
  sc_settings.clear_file();
  
end

end
