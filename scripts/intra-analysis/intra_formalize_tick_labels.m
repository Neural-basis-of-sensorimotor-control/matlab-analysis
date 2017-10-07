function new_tick_labels = intra_formalize_tick_labels(old_tick_labels)

input_is_cell = iscell(old_tick_labels);

if ~input_is_cell
  old_tick_labels = {old_tick_labels};
end

table_stims   = get_intra_motifs();
neurons       = intra_get_neurons();
table_neurons = {neurons.file_tag};

indx = nan(size(old_tick_labels));

new_tick_labels = old_tick_labels;%cell(size(indx));

if any(arrayfun(@(x) any(cellfun(@(y) strcmp(x, y), table_neurons)), old_tick_labels))
  
  for i=1:length(old_tick_labels)
    indx(i) = find(cellfun(@(x) strcmp(x, old_tick_labels{i}), table_neurons));
  end
  
  for i=1:length(indx)
    new_tick_labels(i) = {sprintf('Neuron %d', indx(i))};    
  end
  
elseif any(arrayfun(@(x) any(cellfun(@(y) strcmp(x, y), table_stims)), old_tick_labels))
  
  for i=1:length(old_tick_labels)
    indx(i) = find(cellfun(@(x) strcmp(x, old_tick_labels{i}), table_stims));
  end
  
  for i=1:length(indx)
    new_tick_labels(i) = {sprintf('Stimulation %d', indx(i))};  
  end
  
elseif any(arrayfuyn(@(x) any(cellfun(@(y) startswith(x, y), table_patterns)), old_tick_labels))
  
  for i=1:length(new_tick_labels)
    new_tick_labels(i) = {sprintf('Pattern %d')};
  end
  
else
  
  new_tick_labels = old_tick_labels;
  
end

if ~input_is_cell
  new_tick_labels = new_tick_labels{1};
end

end

