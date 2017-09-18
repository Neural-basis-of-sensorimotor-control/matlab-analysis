function signal = sc_load_signal(neuron)

if length(neuron) ~= 1
  
  signal = vectorize_fcn(@sc_load_signal, neuron);
  return
  
end

file   = sc_load_file(neuron);
signal = file.signals.get('tag', neuron.signal_tag);

signal.update_property_values();

end
