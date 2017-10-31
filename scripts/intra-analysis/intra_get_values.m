function values = intra_get_values(str_stims, neurons, height_limit, min_nbr_epsps, fcn)

values = cell(length(str_stims), length(neurons));

for i_neuron=1:length(neurons)
  
  sc_debug.print(i_neuron, length(neurons))
  
  signal = sc_load_signal(neurons(i_neuron));
  
  for i_stim=1:length(str_stims)
    
    amplitude = signal.amplitudes.get('tag', str_stims{i_stim});
    
    is_response = amplitude.intra_is_significant_response(height_limit, ...
      min_nbr_epsps);
    
    if is_response
      
      x = fcn(amplitude, height_limit) / ...
        intra_get_epsp_amplitude_single_pulse(amplitude, height_limit);
      
      values(i_stim, i_neuron) = {x};
      
    end
    
  end
  
end

end