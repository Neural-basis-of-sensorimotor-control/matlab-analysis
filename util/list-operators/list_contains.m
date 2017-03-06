function val = list_contains(list, property, value)

if nargin < 3
  value = property;
else
  list = get_values(list, property);
end

for i=1:get_list_length(value)
  
  if any(equals(list, get_item(value, i)))
    val = true;
    return
  end
end

val = false;

end