function val = get_items(list, property, value)

if iscell(value)
  indx = false(size(list));
  
  for i=1:length(value)
    indx = indx | equals(get_values(list, property), value{i});
  end
  val = list(indx);
else
  indx = equals(get_values(list, property), value);
  val = list(indx);

end