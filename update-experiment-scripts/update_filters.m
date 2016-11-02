clc
clear

neurons = get_intra_neurons();

for i=1:length(neurons)
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  signal.simple_artifact_filter.is_on = true;
  signal.sc_save(false);
end
