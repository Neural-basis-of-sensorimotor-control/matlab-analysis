function create_waveform(obj, neuron, waveform_tag)

signal = sc_load_signal(neuron);

waveform = ScWaveform(signal, waveform_tag, []);
signal.waveforms.add(waveform);

obj.waveform = waveform;

obj.create_new_threshold();

end
