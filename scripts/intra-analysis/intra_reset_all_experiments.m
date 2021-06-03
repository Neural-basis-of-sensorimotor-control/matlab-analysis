function intra_reset_all_experiments(neurons, response_min, response_max, only_epsps, min_height)

sc_dir = sc_settings.get_default_experiment_dir();

init_raw_data_path(neurons);

update_filtering_template_amplitude(neurons, response_min, response_max, sc_dir);

intra_update_signal_userdata(neurons, only_epsps, min_height);

end

function init_raw_data_path(neurons)

for i=1:length(neurons)
  
  signal = sc_load_signal(neurons(i));
  file = signal.parent;
  experiment = signal.parent.parent;
  
  if ~is_file(file.filepath)
    s1 = fileparts(file.filepath);
    if is_file(s1)
      file.filepath = s1;
    end
  end
  
  experiment.set_fdir(fileparts(update_raw_data_path(file.filepath)));
  save_experiment(experiment, experiment.save_name, false);
  
end

end


function update_filtering_template_amplitude(neurons, response_min, response_max, sc_dir)

for i=1:length(neurons)
  
  sc_debug.print(i, length(neurons));
  
  neuron = neurons(i);
  
  signal = sc_load_signal(neuron);
  
  if ~is_file(signal.parent.filepath)
    
    if signal.parent.prompt_for_raw_data_dir()
      signal.sc_save(false);
    end
    
  end
  
  save_path = [sc_dir neuron.experiment_filename];
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
  signal.sc_save(save_path);
  
end

end
