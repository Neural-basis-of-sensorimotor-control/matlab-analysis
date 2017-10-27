function intra_update_signal_userdata(neurons, only_epsp, min_height)

sc_dir = sc_settings.get_default_experiment_dir();

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
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
        
        tmp_heights = single_pulse.height;
        pos         = tmp_heights > min_height;
        
        if only_epsp
          pos = pos & tmp_heights > 0;
        end
        
        avg_height  = concat_list(avg_height,  single_pulse.height(pos));
        avg_width   = concat_list(avg_width,   single_pulse.width(pos));
        avg_latency = concat_list(avg_latency, single_pulse.latency(pos));
        
      end
      
    end
    
    signal.userdata.single_pulse_height(j) = mean(avg_height);
    signal.userdata.single_pulse_width(j) = mean(avg_width);
    signal.userdata.single_pulse_latency(j) = mean(avg_latency);
    
  end
  
  signal.sc_save([sc_dir tmp_neuron.experiment_filename]);
end

end