function remove_limit(obj, indx)

obj.x(indx)       = [];
obj.y_lower(indx) = [];
obj.y_upper(indx) = [];

for i=1:length(obj.all_objects)
  
  delete(obj.all_objects(i));
  
end

plot_starting_point(obj, obj.x0, obj.y0);

end
