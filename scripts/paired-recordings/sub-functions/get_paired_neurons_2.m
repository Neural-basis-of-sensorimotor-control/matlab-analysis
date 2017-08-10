function val = get_paired_neurons_2(neuron, max_inactivity_time, ...
  min_nbr_of_spikes_per_sequence, min_time_span_per_sequence)

experiment_filename = neuron.experiment_filename;
experiment = ScExperiment.load_experiment(experiment_filename);

if isempty(neuron.file_tag)
  files = neuron.list;
else
  files = get_items(experiment.list, 'tag', neuron.file_tag);
end

val = [];

for i=1:length(files)
  
  file = files(i);
  waveforms = file.get_waveforms();
  
  if ~isempty(neuron.template_tag)
    waveforms = get_items(waveforms, 'tag', neuron.template_tag);
  end
  
  for j=1:length(waveforms)
    
    waveform1 = get_item(waveforms, j);
    spiketimes1 = waveform1.gettimes(neuron.tmin, neuron.tmax);
    
    for k=j+1:length(waveforms)
      
      waveform2 = get_item(waveforms, k);
      spiketimes2 = waveform2.gettimes(neuron.tmin, neuron.tmax);
      
      sequences = find_time_sequences(spiketimes1, spiketimes2, ...
        max_inactivity_time, min_nbr_of_spikes_per_sequence, ...
        min_time_span_per_sequence);
      
      if ~isempty(sequences)
        
        paired_neuron = ScNeuron(file, ...
          'template_tag', {waveform1.tag waveform2.tag}, ...
          'time_sequences', sequences);
        
        val = add_to_list(val, paired_neuron);
      end
    end
  end
end

end