function update_upper_bound(active_object, active_object_group, x_, y_)

for i=1:length(active_object_group)
  
  dim = length(get(active_object_group(i), 'XData'));
  
  if dim == 1
    set(active_object_group(i), 'XData', x_);
  else
    
    set(active_object_group(i), 'XData', x_*[1 1]);
    
    ydata = sort(get(active_object_group(i), 'YData'));
    
    set(active_object_group(i), 'YData', [ydata(1) y_]);
    
  end
  
end

set(active_object, 'YData', y_);

end