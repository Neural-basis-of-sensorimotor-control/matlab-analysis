function update_continuous_signal(signal, min_isi_on, update_objects)

if nargin<2
  min_isi_on = true;
end

all_templates = get_templates(signal);
all_filters = get_filters(signal);

if nargin<3
  
  update_objects = concat_list(all_templates, all_filters);

else
  
  if ~list_contains(update_objects, all_templates) && ...
      ~list_contains(update_objects, all_filters)
    
    return
    
  end
end

v = signal.get_v(false, false, false, false);

unique_indx = unique(cell2mat(get_values([all_templates(:); all_filters(:)], 'process_order')));

for i=1:length(unique_indx)
  
  indx = unique_indx(i);
  filters = get_items(all_filters, 'process_order', indx);
  templates = get_items(all_templates, 'process_order', indx);
  
  for j=1:length(filters)
  
    filter = get_item(filters, j);
    
    filter.update(v);
    v = filter.apply(v);
    update_objects = rm_from_list(update_objects, filter);
    
    if isempty(update_objects)
      return
    end
    
  end
  
  for j=1:length(templates)
    
    template = get_item(templates, j);
    
    if list_contains(update_objects, template)
      template.update(v, min_isi_on);
    end
    
    update_objects = rm_from_list(update_objects, template);
    
    if isempty(update_objects)
      return
    end
    
  end
  
end