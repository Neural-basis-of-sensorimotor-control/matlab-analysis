function val = get_items(list, property, value, max_nbr_of_elements)

if nargin<4
  max_nbr_of_elements = inf;
end

if nargin<=2
  indx = get_list_indx(list, property);
else
  indx = get_list_indx(list, property, value);
end

if ischar(list)
  list = {list};
end

val = list(indx);
val = val(1:min([length(val) max_nbr_of_elements]));

if iscell(val) && length(val)==1
  val = val{1};
end

end