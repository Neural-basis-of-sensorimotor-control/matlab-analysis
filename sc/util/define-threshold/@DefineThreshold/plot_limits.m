function plot_limits(obj)

for i=1:length(obj.x)
  
  plot_single_limit(obj, i);
  
end

clear_objects(obj);

end