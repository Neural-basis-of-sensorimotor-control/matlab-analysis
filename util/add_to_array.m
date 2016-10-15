function list = add_to_array(list, item)

if isempty(list)
  list = item;
elseif iscell(list)
  list(length(list)+1) = {item};
else
  list(length(list)+1) = item;
end
