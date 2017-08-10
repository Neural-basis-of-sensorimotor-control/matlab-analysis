function val = read_sc_settings(property)

val        = '';

filename   = get_sc_settings_filename();
domain_tag = get_current_settings_tag();

if isfile(filename)
  
  try
    
    s = xml2struct(filename);
    
  catch
    
    clear_sc_file();
    warning('Settings file %s appears to be corrupt. Clearing file.', filename);
    return
    
  end
  
  if isfield(s.sc_settings, domain_tag)
    
    if isfield(s.sc_settings.(domain_tag), property)
      
      try
        
        val = s.sc_settings.(domain_tag).(property).Text;
        
        if isempty(val)
          val = '';
        end
        
      catch
        
        warning('Could not find property %s using settings %s in %s file. Setting empty value.', ...
          property, domain_tag, filename);
        
        write_sc_settings(property, '', domain_tag);
        
      end
      
    else
      
      warning('Could not find property %s. Setting empty value.', property);
      write_sc_settings(property, '', domain_tag);
    
    end
    
  else
    
    warning('Could not find settings domain %s. Setting empty values.', domain_tag);
    clear_sc_settings(domain_tag);
    
  end
  
else
  
  warning('Could not find %s settings file. Creating new', filename);
  clear_sc_file();
  
end

end
