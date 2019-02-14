function val = getSelectedTemplate(obj)

indx = obj.indxSelectedTemplate;

if indx > 0
  templates  = obj.getEditableTemplates();
  val        = templates{indx};
else
  val = [];
end

end