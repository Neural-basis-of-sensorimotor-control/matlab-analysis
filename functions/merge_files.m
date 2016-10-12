function merge_files(mergefrom_file, mergeto_file)

for i=1:mergefrom_file.signals.n
  mergefrom_signal = mergefrom_file.signals.get(i);

  if mergeto_file.signals.has('tag', mergefrom_signal.tag)
    mergeto_signal = mergeto_file.signals.get('tag', mergefrom_signal.tag);
    merge_signals(mergefrom_signal, mergeto_signal);
  end
end
