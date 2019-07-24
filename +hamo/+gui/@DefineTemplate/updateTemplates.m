function updateTemplates(obj)

triggableTemplates = obj.getTriggableTemplates();

for i=1:length(triggableTemplates)
  
  template = triggableTemplates{i};
  
  if ~template.isUpdated
    template.triggerIndx = template.match_v(obj.v);
    template.isUpdated   = true;
  end
  
end

end
