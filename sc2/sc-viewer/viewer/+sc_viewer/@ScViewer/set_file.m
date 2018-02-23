function set_file(obj, file)

file = get_item(obj.experiment.list, file);
obj.file = file;

if isempty(file)
  
  obj.set_sequence([]);
  obj.set_signal1([]);
  obj.set_signal2([]);
  obj.set_trigger_parent([]);
  
  return

end

file.update_property_values();
file.sc_loadtimes();

if ~list_contains(file.list, 'tag', 'full')
  
  N = cell2mat(file.signals.values('N'));
  dt = cell2mat(file.signals.values('dt'));
  tmin = 0; tmax = max(N.*dt); tag = 'full';
  sequence = ScSequence(file, tag, tmin, tmax);
  file.add(sequence);
  
end

obj.set_sequence(get_set_val(obj.file.list, obj.sequence, 'full'));

signal1 = get_set_val(obj.file.signals.list, obj.signal1, 'patch');
obj.set_signal1(signal1);

if ~isempty(obj.signal2)
  
  signal2 = get_set_val(obj.file.signals.list, obj.signal2, 'patch2');
  obj.set_signal2(signal2);
  
end

trigger_parents = obj.file.get_triggables();
trigger_parent = get_set_val(trigger_parents, obj.trigger_parent);
obj.set_trigger_parent(trigger_parent);

end
