function move_limits(limit_objects, dx, dy)

for i=1:length(limit_objects)
  
  tmp_object = limit_objects(i);
  
  set(tmp_object, 'XData', get(tmp_object, 'XData') + dx);
  set(tmp_object, 'YData', get(tmp_object, 'YData') + dy);
  
end

end