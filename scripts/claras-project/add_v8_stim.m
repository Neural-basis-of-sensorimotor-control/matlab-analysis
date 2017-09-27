function add_v8_stim(experiment)

for i=1:experiment.n
  add_v8_stim_to_file(experiment.get(i));
end

experiment.sc_save(true);

end


function add_v8_stim_to_file(file)

if file.stims.has('tag', 'V8')
  error('File already has emulated V8 stim electrode');
end

patterns_str = get_patterns();
d = load('intra_data');
intra_patterns = d.intra_patterns;

v8_times = [];

for i=1:length(patterns_str)
  pattern = get_items(intra_patterns.patterns, 'name', patterns_str{i});
  
  if isempty(pattern)
    continue
  end
  
  v4_electrodes = get_items(pattern.stim_electrodes, 'type', 'V4');
  
  triggers = file.gettriggers(0, inf);
  trigger = triggers.get('tag', sprintf('%s dd', patterns_str{i}));
  triggertimes = trigger.gettimes(0, inf);
  
  for j=1:length(v4_electrodes)
    v8_times = [v8_times; triggertimes + v4_electrodes(j).time]; %#ok<AGROW>
  end
  
end

v8_times = sort(v8_times);

emulated_v8_electrode = ScSpikeTrain('V8', v8_times);

if isempty(file.discrete_signals)
    file.discrete_signals = ScCellList();
end

file.discrete_signals.add(emulated_v8_electrode);

end