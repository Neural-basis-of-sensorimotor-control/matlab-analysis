function delete_all_objects(obj)

for i=1:length(obj.all_objects)
  delete(obj.all_objects(i));
end

end