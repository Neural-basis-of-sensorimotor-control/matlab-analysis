function add(obj, item)

if ~obj.counter
  
  if iscell(item)
    obj.values = cell(obj.max_nbr_of_elements, 1);
  else
    obj.values = item;
    obj.values(obj.max_nbr_of_elements) = item;
  end
  
end

obj.counter = obj.counter + 1;
obj.values(obj.counter) = item;

end