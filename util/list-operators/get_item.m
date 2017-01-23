function val = get_item(list, indx)

if isempty(indx)
  val = [];
elseif isobject(indx)
  val = indx;
elseif ischar(indx)
  val = get_items(list, 'tag', indx, 1);
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