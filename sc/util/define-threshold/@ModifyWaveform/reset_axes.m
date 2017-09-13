function reset_axes(obj)

remove_callbacks(obj.h_axes);

for i=1:length(obj.thresholds)
  
  reset_axes(obj.thresholds(i));
  
end

end