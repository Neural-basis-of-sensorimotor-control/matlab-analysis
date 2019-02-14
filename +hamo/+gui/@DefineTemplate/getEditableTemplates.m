function val = getEditableTemplates(obj)

if isempty(obj.signal)
  val = {};
else
  tmpl = obj.signal.templates;
  indx = cellfun(@(x) x.isEditable, tmpl);
  val  = tmpl(indx);
end

end
