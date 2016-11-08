function val = get_item(list, indx)

if iscell(list)
  val = list{indx};
else
  val = list(indx);
end

end