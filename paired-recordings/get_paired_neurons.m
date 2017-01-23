function val = get_paired_neurons(neuron, min_nbr_of_overlapping_spikes)

experiment_filename = neuron.experiment_filename;
experiment = ScExperiment.load_experiment(experiment_filename);

if isempty(neuron.file_tag)
  files = neuron.list;
else
  files = get_items(experiment, 'tag', neuron.file_tag);
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
    tmin1 = min(spiketimes1);
    tmax1 = max(spiketimes1);
    
    for k=j+1:length(waveforms)
      
      waveform2 = get_item(waveforms, k);
      spiketimes2 = waveform2.gettimes(neuron.tmin, neuron.tmax);
      tmin2 = min(spiketimes2);
      tmax2 = max(spiketimes2);
      
      if (nnz( (spiketimes1 > tmin2 & spiketimes1 < tmax2) ) >= ...
          min_nbr_of_overlapping_spikes) ...
          && ...
          (nnz( (spiketimes2 > tmin1 & spiketimes2 < tmax1) ) >= ...
          min_nbr_of_overlapping_spikes)
        
        paired_neuron = ScNeuron(file, ...
          'template_tag', {waveform1.tag waveform2.tag}, ...
          'tmin', neuron.tmin, 'tmax', neuron.tmax);
        
        val = add_to_list(val, paired_neuron);
      end
    end
  end
end

end