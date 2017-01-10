function list = add_item_to_list(list, item)

if isempty(list)
  list = item;
elseif iscell(list)
  list(length(list)+1) = {item};
else
  list(length(list)+1) = item;
end