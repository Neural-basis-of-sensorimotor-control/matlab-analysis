function val = get_filters(signal)

val = {signal.filter};
val(end+1:end+signal.remove_waveforms.n) = signal.remove_waveforms.cell_list;
val(end+1) = {signal.simple_artifact_filter};
val(end+1) = {signal.simple_spike_filter};

