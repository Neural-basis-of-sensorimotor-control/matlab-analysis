function reset_axes(obj)

for i=1:length(obj.all_objects)
  
  delete(obj.all_objects(i));
  
end

obj.all_objects = [];

clear_objects(obj);

end