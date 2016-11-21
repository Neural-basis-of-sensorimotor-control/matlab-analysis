clc
clear

sc_dir = get_intra_experiment_dir();

response_min = 4e-3;
response_max = 22e-3;

neurons = get_intra_neurons();

for i1=1:length(neurons)
   fprintf('%d out of %d\n', i1, length(neurons));
   neuron = neurons(i1);

  signal = sc_load_signal(neuron, 'check_raw_data_dir', true);
  signal.simple_artifact_filter.is_on = true;
  signal.simple_spike_filter.is_on = true;

  templates = signal.get_templates();
  psp_templates = get_items(templates, 'tag', neuron.psp_templates);

  for j1=1:length(psp_templates)
    psp = get_item(psp_templates, j1);
    %TODO: add check for isempty - remove if is empty
    psp.process_order = 1;
  end
  signal.update_continuous_signal;

  update_amplitudes(neuron, response_min, response_max, true);
  signal.sc_save([sc_dir signal.parent.parent.save_name]);
end
stims = get_intra_motifs();
electrodes = {'V1', 'V2', 'V3', 'V4'};
neurons = get_intra_neurons();

for i2=1:length(electrodes)
  fprintf('%d (%d)\n', i2, length(electrodes));
  electrode = electrodes{i2};
  indx = find(cellfun(@(x) ~isempty(regexp(x, electrode, 'once')), stims));
  
  for j2=1:length(neurons)
    fprintf('\t%d (%d)\n', j2, length(neurons));
    neuron = neurons(i2);
    signal = sc_load_signal(neuron);
    vals = nan(length(indx), 3);
    
    for k=1:length(indx)
      stim = stims{indx(k)};
      amplitude = get_items(signal.amplitudes.cell_list, 'tag', stim);
      
      vals(k, 1) = mean(amplitude.height);
      vals(k, 2) = mean(amplitude.latency);
      vals(k, 3) = mean(amplitude.width);
    end
    
    user_data_field = sprintf('epsp_%s', electrode);
    signal.userdata.(user_data_field) = vals;
    signal.sc_save([sc_dir signal.parent.parent.save_name]);  
  end
end

update_signal_userdata


