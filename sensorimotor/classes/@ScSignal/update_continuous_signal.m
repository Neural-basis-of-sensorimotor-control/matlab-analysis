function update_continuous_signal(signal)

v = signal.get_v(false, false, false, false);

all_templates = get_templates(signal);
all_filters = get_filters(signal);

unique_indx = unique(cell2mat(get_values([all_templates(:); all_filters(:)], 'process_order')));

for i=1:length(unique_indx)
  indx = unique_indx(i);
  
  filters = get_items(all_filters, 'process_order', indx);
  templates = get_items(all_templates, 'process_order', indx);
  
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