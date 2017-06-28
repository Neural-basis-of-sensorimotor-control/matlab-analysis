function val = get_list_length(list)

if isempty(list)
  val = 0;
elseif iscell(list)
  val = length(list);
elseif ischar(list)
  val = 1;
else
  val = length(list);
end

end