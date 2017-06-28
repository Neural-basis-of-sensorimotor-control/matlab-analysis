function is_equal = spiketrains_are_equal(neuron1, neuron2)

tag1 = strrep(neuron1.tag, '_', '-');
tag1 = strrep(tag1, '"', '');
tag1 = strrep(tag1, '''', '');

tag2 = strrep(neuron2.tag, '_', '-');
tag2 = strrep(tag2, '"', '');
tag2 = strrep(tag2, '''', '');

is_equal = strcmp(neuron1.file_tag, neuron2.file_tag) && ...
  strcmp(neuron1.signal_tag, neuron2.signal_tag) && ...
  strcmp(tag1, tag2);

end