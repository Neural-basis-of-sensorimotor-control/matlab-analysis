clc
clear

sc_dir = get_default_experiment_dir();

response_min = 4e-3;
response_max = 22e-3;

neurons = get_intra_neurons();

%Update raw data path
for i1=1:length(neurons)
  signal = sc_load_signal(neurons(i1));
  file = signal.parent;
  experiment = signal.parent.parent;
  
  if ~isfile(file.filepath)
    s1 = fileparts(file.filepath);
    if isfile(s1)
      file.filepath = s1;
    end
  end
  
  experiment.fdir = fileparts(update_raw_data_path(file.filepath));
  save_experiment(experiment, experiment.abs_save_path, false);
end

%Update filtering, template matching and amplitude epsps
for i2=1:length(neurons)
   fprintf('%d out of %d\n', i2, length(neurons));
   neuron = neurons(i2);

  signal = sc_load_signal(neuron, 'check_raw_data_dir', true);
  signal.simple_artifact_filter.is_on = true;
  signal.simple_spike_filter.is_on = false;

  templates = signal.get_templates();
  psp_templates = get_items(templates, 'tag', neuron.psp_templates);

  for j2=1:length(psp_templates)
    psp = get_item(psp_templates, j2);
    %TODO: add check for isempty - remove if is empty
    psp.process_order = 1;
  end
  
  signal.update_continuous_signal(false);
  signal.update_amplitudes(neuron, response_min, response_max, true);
  signal.sc_save([sc_dir signal.parent.parent.save_name]);
end
stims = get_intra_motifs();
electrodes = {'V1', 'V2', 'V3', 'V4'};
neurons = get_intra_neurons();

%Update userdata for amplitudes and parent signals
for i3=1:length(electrodes)
  fprintf('%d (%d)\n', i3, length(electrodes));
  electrode = electrodes{i3};
  indx = find(cellfun(@(x) ~isempty(regexp(x, electrode, 'once')), stims));
  
  for j3=1:length(neurons)
    fprintf('\t%d (%d)\n', j3, length(neurons));
    neuron = neurons(j3);
    signal = sc_load_signal(neuron);
    vals = nan(length(indx), 3);
    
    for k3=1:length(indx)
      stim = stims{indx(k3)};
      amplitude = get_items(signal.amplitudes.cell_list, 'tag', stim);
      
      vals(k3, 1) = mean(amplitude.height);
      vals(k3, 2) = mean(amplitude.latency);
      vals(k3, 3) = mean(amplitude.width);
    end
    
    user_data_field = sprintf('epsp_%s', electrode);
    signal.userdata.(user_data_field) = vals;
    
    signal.sc_save([sc_dir signal.parent.parent.save_name]);  
  end
end

update_signal_userdata


