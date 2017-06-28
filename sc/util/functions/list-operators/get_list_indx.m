function indx = get_list_indx(list, property, value)

if nargin == 2
  
  if isnumeric(property)
    indx = property;
    return
  end
  
  value = property;
end

if iscell(value)
  indx = false(size(list));
  
  for i=1:get_list_length(value)
    
    if nargin == 2
      indx = indx | equals(list, value{i});
    else
      indx = indx | equals(get_values(list, property), value{i});
    end
  end
  
else
  
  if nargin == 2
    indx = equals(list, value);
  else
    indx = equals(get_values(list, property), value);
  end
end

end