function set_file(obj, file)

file = get_item(obj.experiment, file);
obj.file = file;

if isempty(file)
  obj.set_sequence([]);
  return
end

file.sc_loadtimes();

if ~file.n
  N = cell2mat(file.signals.values('N'));
  dt = cell2mat(file.signals.values('dt'));
  tmin = 0; tmax = max(N.*dt); tag = 'full';
  sequence = ScSequence(file, tag, tmin, tmax);
  file.add(sequence);
  obj.set_sequence(sequence);
elseif file.contains(obj.sequence)
  obj.set_sequence(obj.sequence);
elseif sc_contains(file.values('tag'),'full')
  obj.set_sequence(obj.file.get('tag','full'));
else
  obj.set_sequence(obj.file.get(1));
end

end
