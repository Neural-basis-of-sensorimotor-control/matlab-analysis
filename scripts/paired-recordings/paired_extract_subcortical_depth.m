function [depth1, depth2] = paired_extract_subcortical_depth(protocol_file, file_tag, signal_tag)

depth1 = nan;
depth2 = nan;

if strcmp(signal_tag, 'patch')
  depth1 = -1;
elseif strcmp(signal_tag, 'patch2')
  depth2 = -1;
else
  error('Unknown signal tag: %s', signal_tag);
end


fid          = fopen(protocol_file, 'r');
at_last_file = false;

while true
  
  line = fgetl(fid);
  
  if ~isempty(line) && isnumeric(line) && line == -1
    
    fclose(fid);
    return
  
  end
  
  if startsWith(line, '¤¤')
    
    if at_last_file
      
      fclose(fid);
      return
      
    end
      
    tmp_file_tag = strtrim(line(3:end));
    at_last_file = strcmp(file_tag, tmp_file_tag);
      
  end
  
  if ~isempty(regexp(line, '%%celluns \d+\.?\d* com', 'once'))
    
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
  end
  
end
