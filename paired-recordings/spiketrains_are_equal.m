function is_equal = spiketrains_are_equal(neuron1, neuron2)

is_equal = strcmp(neuron1.file_tag, neuron2.file_tag) && ...
  strcmp(neuron1.signal_tag, neuron2.signal_tag) && ...
  strcmp(neuron1.tag, neuron2.tag);

end