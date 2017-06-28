neurons = get_intra_neurons();
sc_dir = get_default_experiment_dir();

%neuron_indx = 20;
neuron = neurons(neuron_indx);

sc([sc_dir neuron.experiment_filename]);

h.viewer.set_file(neuron.file_tag);
h.viewer.set_main_signal(neuron.signal_tag);
