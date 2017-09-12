function sc_save(obj, varargin)

for i=1:length(obj.thresholds)
  
  if obj.thresholds(i).has_unsaved_changes
    sc_save(obj.thresholds(i), varargin{:});
  end
  
end

end