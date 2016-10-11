function sc_add_wsg_template(file, wsg_filename)

template_names = strsplit(wsg_filename, '+');
for i=1:length(template_names)
  [~, name] = fileparts(template_names{i});
  name = deblank(name);
  template_names(i) = {name};
end

sc_read_wsg_templates(file, wsg_filename, template_names);


end