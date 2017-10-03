function reset_axes(obj)

remove_callbacks(obj.h_axes);

for i=1:length(obj.all_objects)
  
  delete(obj.all_objects(i));
  
end

obj.all_objects = [];

obj.threshold_has_been_plotted = false;

clear_objects(obj);

end