function update_threshold(obj)

for i=1:length(obj.thresholds)
  
  if obj.thresholds(i).has_unsaved_changes
    update_threshold(obj.thresholds(i));
  end
  
end

end