function val = getTriggableTemplates(obj)

if isempty(obj.signal)
  val = {};
else
  tmpl = obj.signal.templates;
  indx = cellfun(@(x) x.isTriggable, tmpl);
  val  = tmpl(indx);
end

end
