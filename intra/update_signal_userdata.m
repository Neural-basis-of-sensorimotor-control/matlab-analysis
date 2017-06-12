function update_signal_userdata(neurons, only_epsp)

sc_dir = get_default_experiment_dir();

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons));
  tmp_neuron = neurons(i);
  signal = sc_load_signal(tmp_neuron);
  
  signal.userdata.single_pulse_height = [];
  signal.userdata.single_pulse_width = [];
  signal.userdata.single_pulse_latency = [];
  
  for j=1:4
    
    avg_height = [];
    avg_width = [];
    avg_latency = [];
    
    single_stims_str = get_single_amplitudes(num2str(j));
    
    for k=1:length(single_stims_str)
      single_str = single_stims_str{k};
      
      if list_contains(signal.amplitudes.cell_list, 'tag', single_str)
        
        single_pulse = get_item(signal.amplitudes.cell_list, single_str);
        
        if ~only_epsp || single_pulse.height > 0
         
          avg_height = [avg_height; single_pulse.height];
          avg_width = [avg_width; single_pulse.width];
          avg_latency = [avg_latency; single_pulse.latency];
        
        end
      
      end
      
    end
    
    signal.userdata.single_pulse_height(j) = mean(avg_height);
    signal.userdata.single_pulse_width(j) = mean(avg_width);
    signal.userdata.single_pulse_latency(j) = mean(avg_latency);
  
  end
  
  signal.sc_save([sc_dir tmp_neuron.experiment_filename]);
end

end