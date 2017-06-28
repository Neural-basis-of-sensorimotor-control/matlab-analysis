function set_file(obj, file)

file = get_item(obj.experiment.list, file);
obj.file = file;

if isempty(file)
  obj.set_sequence([]);
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
  
elseif file.contains(obj.sequence)
  obj.set_sequence(obj.sequence);
  
elseif sc_contains(file.values('tag'), 'full')
  obj.set_sequence(obj.file.get('tag', 'full'));
  
else
  obj.set_sequence(obj.file.get(1));
  
end

end
