function list = add_to_list(list, item)

if isempty(list)
  
  if iscell(list) || ischar(item)
    list = {item};
  else
    list = item;
  end 
  
elseif iscell(list)
  
  list(length(list)+1) = {item};

elseif ischar(list)

  list = {list};
  list = add_to_list(list, item);

else
  
  if ~isempty(item)
    list(length(list)+1) = item;
  end
  
end

end