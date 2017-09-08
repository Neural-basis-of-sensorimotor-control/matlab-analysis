function thr = paired_create_define_threshold(fig)


[thr, neuron] = paired_get_associated_define_threshold(fig);

signal = sc_load_signal(neuron);

signal.waveforms.values('tag')

