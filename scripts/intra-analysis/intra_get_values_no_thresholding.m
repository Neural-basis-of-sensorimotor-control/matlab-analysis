function values = intra_get_values_no_thresholding(str_stims, neurons, fcn)

values = cell(length(str_stims), length(neurons));

for i_neuron=1:length(neurons)
  
  sc_debug.print(i_neuron, length(neurons))
  
  signal = sc_load_signal(neurons(i_neuron));
  
  for i_stim=1:length(str_stims)
    
    amplitude                = signal.amplitudes.get('tag', str_stims{i_stim});
    
    if ~isempty(amplitude)
    
      x                        = fcn(amplitude);
      values(i_stim, i_neuron) = {x};
    
    end
    
  end
  
end

end
