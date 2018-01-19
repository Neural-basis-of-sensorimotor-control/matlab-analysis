function new_val = get_set_val(list, old_val, default_ind)

if nargin < 3
  default_ind = 1;
end

if ischar(default_ind)
  
  default_ind = find(...
    cellfun(@(x) strcmp(x, default_ind), get_values(list,'tag')), 1);
  
elseif isobject(default_ind)
  
  if iscell(list)
    
    default_ind = find(...
      cellfun(@(x) x == default_ind, list), 1);
    
  else
    
    default_ind = find(x == default_ind, 1);
  
  end
  
end

if isempty(default_ind)
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
  
elseif ~isnumeric(old_val) && ~ischar(old_val) && ...
    list_contains(list, 'tag', old_val.tag)
  
  new_val = get_items(list, 'tag', old_val.tag, 1);
  
else
  
  new_val = get_item(list, 1);
  
end

end
