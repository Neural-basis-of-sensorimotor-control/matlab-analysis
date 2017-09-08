function paired_save_waveform(thr, fig)

[~, neuron] = paired_get_associated_define_threshold(fig);
signal = sc_load_signal(neuron);
signal.waveforms.add(thr.waveform);
thr.waveform.parent = signal;

signal.sc_save(false)