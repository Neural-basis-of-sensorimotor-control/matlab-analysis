function merge_signal_remove_waveforms(mergefrom_signal, mergeto_signal)

for i=1:mergefrom_signal.remove_waveforms.n
  mergefrom_rmwf = mergefrom_signal.remove_waveform.get(i);

  tag = mergefrom_rmwf.tag;
  while mergeto_signal.remove_waveform.has('tag', tag)
    tag = [tag '*']; %#ok<AGROW>
  end

  mergeto_rmwf = mergefrom_rmwf.create_copy(mergeto_signal);
  mergeto_rmwf.tag = tag;
  mergeto_signal.remove_waveform.add(mergeto_rmwf);
end

end
