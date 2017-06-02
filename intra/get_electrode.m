function [char_val, num_val] = get_electrode(stim)

if iscell(stim) || (~ischar(stim) && length(stim) > 1)
  
  char_val = cell(size(stim));
  num_val = nan(size(stim));
  
  for i=1:length(stim)
    [tmp_char_val, num_val(i)] = get_electrode(get_item(stim, i));
    
    char_val(i) = {tmp_char_val};
  end
  
else
  
  if ~ischar(stim)
    stim = stim.tag;
  end
  
  str = strsplit(stim, '#');
  char_val =  str{2};
  
  if nargout>1
    num_val = str2double(char_val(2));
  end
  
end

end