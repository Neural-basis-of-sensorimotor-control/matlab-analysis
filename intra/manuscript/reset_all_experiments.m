clc
clear

response_min = 5e-3;
response_max = 3e-2;
remove_fraction = .1;

neurons = get_intra_neurons();

for i=1:length(neurons)
  neuron = neurons(i);
  
  signal = sc_load_signal(neuron);
  signal.simple_artifact_filter.is_on = true;
  signal.simple_spike_filter.is_on = true;
  
  templates = signal.get_templates();
  psp_templates = get_items(templates, 'tag', neuron.psp_templates);
  
  for j=1:length(psp_templates)
    psp = get_item(psp_templates, j);
    psp.process_order = 1;
  end
  
  signal.update_continuous_signal;
  
  signal.update_amplitudes(psp_templates, response_min, response_max, remove_fraction);
  
  return
  
  
end