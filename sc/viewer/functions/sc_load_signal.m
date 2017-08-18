function signal = sc_load_signal(neuron)

if length(neuron) ~= 1    
  
  signal = vectorize_fcn(@sc_load_signal, neuron);

else

  expr = ScExperiment.load_experiment(neuron.experiment_filename);  
  file = expr.get('tag', neuron.file_tag);
  signal = file.signals.get('tag', neuron.signal_tag);

end

signal.update_property_values();

end
