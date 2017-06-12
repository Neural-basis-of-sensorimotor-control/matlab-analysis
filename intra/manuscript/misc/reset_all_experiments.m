function reset_all_experiments(neurons, response_min, response_max, only_epsps)

electrodes = {'V1', 'V2', 'V3', 'V4'};

stims_str = get_intra_motifs();

update_raw_data_path(neurons);

update_filtering_template_amplitude(neurons, response_min, response_max, sc_dir);

update_amplitude_parent_userdata(only_epsps, neurons, stims_str, electrodes, sc_dir);

update_signal_userdata(neurons, only_epsp);

end

function update_raw_data_path(neurons)

for i=1:length(neurons)
  
  signal = sc_load_signal(neurons(i));
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

end


function update_filtering_template_amplitude(neurons, response_min, response_max, sc_dir)

for i=1:length(neurons)
  
  fprintf('%d out of %d\n', i, length(neurons));
  
  neuron = neurons(i);
  
  signal = sc_load_signal(neuron, 'check_raw_data_dir', true);
  signal.simple_artifact_filter.is_on = true;
  signal.simple_spike_filter.is_on = false;
  
  templates = signal.get_templates();
  psp_templates = get_items(templates, 'tag', neuron.template_tag);
  
  for j2=1:length(psp_templates)
    
    psp = get_item(psp_templates, j2);
    %TODO: add check for isempty - remove if is empty
    psp.process_order = 1;
    
  end
  
  signal.update_continuous_signal(false);
  signal.update_amplitudes(neuron, response_min, response_max, true);
  signal.sc_save([sc_dir signal.parent.parent.save_name]);
  
end

end


function update_amplitude_parent_userdata(only_epsps, neurons, stims_str, electrodes, sc_dir)

for i=1:length(electrodes)
  
  fprintf('%d (%d)\n', i, length(electrodes));
  
  electrode = electrodes{i};
  indx = find(cellfun(@(x) ~isempty(regexp(x, electrode, 'once')), stims_str));
  
  for j=1:length(neurons)
    
    fprintf('\t%d (%d)\n', j, length(neurons));
    
    neuron = neurons(j);
    signal = sc_load_signal(neuron);
    vals = nan(length(indx), 3);
    
    for k=1:length(indx)
      
      stim = stims_str{indx(k)};
      amplitude = get_items(signal.amplitudes.cell_list, 'tag', stim);
      
      if only_epsps
        heights = amplitude.height;
        
        if isempty(heights>0)
          error('No EPSPs in single pulses');
        end
        
        vals(k, 1) = mean(amplitude.height(heights>=0));
        vals(k, 2) = mean(amplitude.latency(heights>=0));
        vals(k, 3) = mean(amplitude.width(heights>=0));
      
      else
        
        vals(k, 1) = mean(amplitude.height);
        vals(k, 2) = mean(amplitude.latency);
        vals(k, 3) = mean(amplitude.width);
      
      end
      
    end
    
    user_data_field = sprintf('epsp_%s', electrode);
    signal.userdata.(user_data_field) = vals;
    
    signal.sc_save([sc_dir signal.parent.parent.save_name]);
    
  end
end

end