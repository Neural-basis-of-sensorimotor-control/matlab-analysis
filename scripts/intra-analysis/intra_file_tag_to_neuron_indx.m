function str_label = intra_file_tag_to_neuron_indx(arg_in, neurons)

if ischar(arg_in) || (isnumeric(arg_in) && length(arg_in) == 1)
  
  if ischar(arg_in)    
    indx = find(cellfun(@(x) strcmp(x, arg_in), {neurons.file_tag}));
  else
    indx = arg_in;
  end
    
  if startswith(neurons(indx).file_tag, 'ICNR') || startswith(neurons(indx).file_tag, 'IDNR')
    str_label = sprintf('Neuron %.2d *', indx);
  elseif startswith(neurons(indx).file_tag, 'IFNR')
    str_label = sprintf('Neuron %.2d **', indx);
  else
    str_label = sprintf('Neuron %.2d', indx);
  end
  
elseif iscell(arg_in)
  
  str_label = cell(size(arg_in));
  
  for i=1:length(arg_in)
    str_label(i) = {intra_file_tag_to_neuron_indx(arg_in{i}, neurons)};
  end
  
else
  
  error('Unknown input %s', class(arg_in));
  
end


end