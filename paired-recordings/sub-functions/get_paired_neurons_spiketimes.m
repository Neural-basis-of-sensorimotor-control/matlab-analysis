function [spiketimes1, spiketimes2, waveform1, waveform2] = get_paired_neurons_spiketimes(paired_neurons)
% [spiketimes1, spiketimes2] = get_paired_neurons_spiketimes(paired_neurons)
% paired_neurons      ScNeuron object

if isa(paired_neurons, 'ScNeuron')
  expr_fname = [get_default_experiment_dir() paired_neurons.experiment_filename];
  expr = ScExperiment.load_experiment(expr_fname);

  file = get_item(expr.list, paired_neurons.file_tag);
  waveforms = file.get_waveforms();

  tmin = paired_neurons.tmin;
  tmax = paired_neurons.tmax;

  waveform1 = get_item(waveforms, paired_neurons.template_tag{1});
  waveform2 = get_item(waveforms, paired_neurons.template_tag{2});

  spiketimes1 = waveform1.gettimes(tmin, tmax);
  spiketimes2 = waveform2.gettimes(tmin, tmax);
else
  spiketimes1 = paired_neurons.neuron1.get_spiketimes();
  spiketimes2 = paired_neurons.neuron2.get_spiketimes();
  waveform1 = paired_neurons.neuron1;
  waveform2 = paired_neurons.neuron2;
end

end