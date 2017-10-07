function [depth1, depth2] = paired_extract_subcortical_depth(protocol_file, ...
  file_tag, protocol_signal_tag)

depth1 = nan;
depth2 = nan;

if strcmp(protocol_signal_tag, 'patch') || ...
    strcmp(protocol_signal_tag, 'patch1')
  
  depth1 = 0;
  
elseif strcmp(protocol_signal_tag, 'patch2')
  
  depth2 = 0;
  
else
  
  error('Unknown signal tag: %s', protocol_signal_tag);
  
end


fid          = fopen(protocol_file, 'r');
at_last_file = false;

while true
  
  line = fgetl(fid);
  
  if ~isempty(line) && isnumeric(line) && line == -1
    
    fclose(fid);
    return
    
  end
  
  if startswith(line, '¤¤')
    
    if at_last_file
      
      fclose(fid);
      return
      
    end
    
    tmp_file_tag = strtrim(line(3:end));
    at_last_file = strcmp(file_tag, tmp_file_tag);
    
  end
  
  if ~isempty(regexp(line, '%%\w+ \d+\.?\d* com', 'once'))
    
    enc_str     = strsplit(line);
    str_depth   = enc_str{2};
    str_channel = enc_str{4};
    
    switch str_channel
      
      case {'patch' 'patch1' 'patch1,'}
        depth1 = str2num(str_depth);
      case 'patch2'
        depth2 = str2num(str_depth);
      otherwise
        error('Could not parse: %s', line);
        
    end
    
  elseif strcmp(line, 'patch2 664 um, patch1 560um')
    
    depth1 = .56;
    depth2 = .664;
    
  end
  
end

end
