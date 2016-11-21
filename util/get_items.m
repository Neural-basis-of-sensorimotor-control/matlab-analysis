function val = get_items(list, property, value, max_nbr_of_elements)

if nargin<4
  max_nbr_of_elements = inf;
end

if iscell(value)
  indx = false(size(list));
  
  for i=1:length(value)
    indx = indx | equals(get_values(list, property), value{i});
  end
elseif ischar(value) || isnumeric(value)
  indx = equals(get_values(list, property), value);
end

val = list(indx);
val = val(1:min([length(val) max_nbr_of_elements]));

if iscell(val) && length(val)==1
  val = val{1};
end

end