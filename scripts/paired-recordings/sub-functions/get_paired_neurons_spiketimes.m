function [spiketimes1, spiketimes2, waveform1, waveform2] = get_paired_neurons_spiketimes(paired_neurons)
% [spiketimes1, spiketimes2] = get_paired_neurons_spiketimes(paired_neurons)
% paired_neurons      ScNeuron object

if isa(paired_neurons, 'ScNeuron')
  [spiketimes1, spiketimes2, waveform1, waveform2] = get_neuron_spiketime(paired_neurons);
  
elseif isa(paired_neurons, 'ScSpikeTrainCluster')
  spiketimes1 = paired_neurons.neurons(1).get_spiketimes();
  spiketimes2 = paired_neurons.neurons(2).get_spiketimes();
  waveform1 = paired_neurons.neurons(1);
  waveform2 = paired_neurons.neurons(2);
  
else
  spiketimes1 = paired_neurons.neuron1.get_spiketimes();
  spiketimes2 = paired_neurons.neuron2.get_spiketimes();
  waveform1 = paired_neurons.neuron1;
  waveform2 = paired_neurons.neuron2;
  
end

end