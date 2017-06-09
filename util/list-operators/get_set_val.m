function new_val = get_set_val(list, old_val, default_ind)

if nargin<3
  default_ind = 1;
end

default_ind = min([default_ind length(list)]);

if isempty(list)
  new_val = [];
  
elseif isempty(old_val)
  new_val = get_item(list, default_ind);
  
elseif list_contains(list, old_val)
  indx = equals(list, old_val);
  new_val = get_item(list, find(indx, 1));
  
elseif list_contains(list, 'tag', old_val.tag)
  new_val = get_items(list, 'tag', old_val.tag, 1);
  
else
  new_val = get_item(list, 1);
  
end

end
