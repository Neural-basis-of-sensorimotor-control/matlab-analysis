clc
clear

response_min = 4e-3;
response_max = 22e-3;
remove_fraction = .1;

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
  
  signal.update_amplitudes(neuron.tmin, neuron.tmax, ...
    neuron.psp_templates, response_min, response_max, remove_fraction, true);
  signal.sc_save(false);
end
stims = get_intra_motifs();
electrodes = {'V1', 'V2', 'V3', 'V4'};
neurons = get_intra_neurons();

for i2=1:length(electrodes)
  fprintf('%d (%d)\n', i2, length(electrodes));
  electrode = electrodes{i2};
  indx = find(cellfun(@(x) ~isempty(regexp(x, electrode, 'once')), stims));
  
  for j2=1:length(neurons)
    fprintf('%d (%d)\n', j2, length(neurons));
    neuron = neurons(i2);
    signal = sc_load_signal(neuron);
    vals = nan(length(indx), 3);
    
    for k=1:length(indx)
      stim = stims{indx(k)};
      amplitude = get_items(signal.amplitudes.cell_list, 'tag', stim);
      
      if amplitude.response_is_significant(signal.userdata.spont_activity)
        vals(k, 1) = mean(amplitude.rise_automatic_detection);
        vals(k, 2) = mean(amplitude.latency(~amplitude.is_pseudo));
        vals(k, 3) = nnz(amplitude.automatic_xpsp_detected)/length(amplitude.stimtimes);
      else
        vals(k) = 0;
      end
    end
    
    user_data_field = sprintf('epsp_%s', electrode);
    signal.userdata.(user_data_field) = vals;
    signal.sc_save(false);
  end  
end
