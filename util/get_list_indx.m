function indx = get_list_indx(list, property, value)

if iscell(value)
  indx = false(size(list));
  
  for i=1:length(value)
    indx = indx | equals(get_values(list, property), value{i});
  end
elseif ischar(value) || isnumeric(value)
  indx = equals(get_values(list, property), value);
end

end