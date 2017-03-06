function list = add_to_list(list, item)

if isempty(list)
  list = item;
elseif iscell(list)
  list(length(list)+1) = {item};
elseif ischar(list)
  list = {list};
else
  list(length(list)+1) = item;
end
