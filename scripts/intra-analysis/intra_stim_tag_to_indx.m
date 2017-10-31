function str_label = intra_stim_tag_to_indx(arg_in, stims)

if ischar(arg_in) || (isnumeric(arg_in) && length(arg_in) == 1)
  
  if ischar(arg_in)
    indx = find(cellfun(@(x) strcmp(x, arg_in), stims));
  else
    indx = arg_in;
  end
  
  str_label = sprintf('Stimulation %d', indx);
  
elseif iscell(arg_in)
  
  str_label = cell(size(arg_in));
  
  for i=1:length(arg_in)
    str_label(i) = {intra_stim_tag_to_indx(arg_in{i}, stims)};
  end
  
else
  
  error('Unknown input %s', class(arg_in));
  
end


end