function v = sc_matlab2py_get_v(experiment_filename, file_tag, signal_tag)

neuron = ScNeuron('experiment_filename', experiment_filename, ...
  'file_tag', file_tag, 'signal_tag', signal_tag);

signal = sc_load_signal(neuron);

v = signal.get_v(true, true, true, true);

end