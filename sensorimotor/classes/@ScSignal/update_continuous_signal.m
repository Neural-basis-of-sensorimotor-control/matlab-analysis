function update_continuous_signal(signal)

v = signal.get_v(false, false, false, false);

templates = get_templates(signal);
filters = get_filters(signal);

unique_indx = unique(cell2mat(get_values([templates(:); filters(:)], 'process_order')));

for i=1:length(unique_indx)
  indx = unique_indx(i);
  
  filters = get_items(filters, 'process_order', indx);
  templates = get_items(templates, 'process_order', indx);
  
  for j=1:length(filters)
    filter = get_item(filters, j);
    filter.update(v);
    v = filter.apply(v);
  end
  
  for j=1:length(templates)
    template = get_item(templates, j);
    template.update(v);    
  end
  
end