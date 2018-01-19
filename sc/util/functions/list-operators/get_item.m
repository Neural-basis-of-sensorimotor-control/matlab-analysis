function val = get_item(list, indx)

if isempty(indx)

  val = [];
  
elseif isobject(indx)
  
  val = indx;

elseif ischar(indx)
  
  if iscell(list) && ischar(list{1})
    
    indx = find(cellfun(@(x) strcmp(x, indx), list), 1);
    val = list{indx};
  
  else
    
    val = get_items(list, 'tag', indx, 1);

  end
  
elseif ischar(list)
  
  list = {list};
  val = list(indx);

else
  
  val = list(indx);
  
  if length(val) > 1
    val = val(1);
  end
  
end

if iscell(val) && length(val)==1
  val = val{1};
end

end