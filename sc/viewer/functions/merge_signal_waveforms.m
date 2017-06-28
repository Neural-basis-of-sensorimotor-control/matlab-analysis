function merge_signal_waveforms(mergefrom_signal, mergeto_signal)

for i=1:mergefrom_signal.waveforms.n
  mergefrom_waveform = mergefrom_signal.waveforms.get(i);

  tag = mergefrom_waveform.tag;
  while mergeto_signal.waveforms.has('tag', tag)
    tag = [tag '*']; %#ok<AGROW>
  end

  mergeto_waveform = ScWaveform(mergeto_signal, tag, []);
  for j=1:length(mergefrom_waveform.n)
    mergefrom_threshold = mergefrom_waveform.get(j);
    mergeto_waveform.add(mergefrom_threshold.create_copy());
  end
  mergeto_signal.waveforms.add(mergeto_waveform);
end

end
