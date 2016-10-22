neurons = get_intra_neurons();
sc_dir = get_intra_experiment_dir();

%neuron_indx = 20;
neuron = neurons(neuron_indx);

sc([sc_dir neuron.expr_file]);

h.viewer.set_file(neuron.file_str);
h.viewer.set_main_signal(neuron.signal_str);
