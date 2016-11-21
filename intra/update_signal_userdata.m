clc
clear

neurons = get_intra_neurons();
sc_dir = get_intra_experiment_dir;
for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons));
  neuron = neurons(i);
  signal = sc_load_signal(neuron);
  
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
        avg_height = [avg_height; single_pulse.height];
        avg_width = [avg_width; single_pulse.width];
        avg_latency = [avg_latency; single_pulse.latency];
      end
    end
    signal.userdata.single_pulse_height(j) = mean(avg_height);
    signal.userdata.single_pulse_width(j) = mean(avg_width);
    signal.userdata.single_pulse_latency(j) = mean(avg_latency);
  end
  
  signal.sc_save([sc_dir neuron.expr_file]);
end