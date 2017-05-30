function [val, common_sequence] = spiketrain_matches(spike_train_cluster_list, ...
  spikedata1, spikedata2, same_channel, different_channels, max_idle_time)

val = false;
common_sequence = [];

if ~strcmp(spikedata1.file_tag, spikedata2.file_tag)
  return
end

if neurons_match(spikedata1, spikedata2)
  return
end

is_same_channel = same_channel && strcmp(spikedata1.signal_tag, spikedata2.signal_tag);
is_different_channels = different_channels && ~strcmp(spikedata1.signal_tag, spikedata2.signal_tag);

if ~is_same_channel && ~is_different_channels
  return
end

indx1 = arrayfun(@(x) any(x.neurons == spikedata1), spike_train_cluster_list);
indx2 = arrayfun(@(x) any(x.neurons == spikedata2), spike_train_cluster_list);

if any(indx1 & indx2)
  return
end

indx1 = arrayfun(@(x) neurons_match(x.neurons, spikedata1), spike_train_cluster_list);
indx2 = arrayfun(@(x) neurons_match(x.neurons, spikedata2), spike_train_cluster_list);

if any(indx1 & indx2)
  return
end
t1 = spikedata1.gettimes(0, inf);
t2 = spikedata2.gettimes(0, inf);

sequence1 = get_sequence(t1, max_idle_time);
sequence2 = get_sequence(t2, max_idle_time);

common_sequence = range_intersection(sequence1', sequence2');

indx = 1:2:length(common_sequence);
common_sequence = common_sequence([indx' indx'+1]);

t1 = extract_within_sequence(t1, common_sequence);
t2 = extract_within_sequence(t2, common_sequence);

if length(t1) == length(t2) && ~max(abs(t2-t1))
  val = false;
else
  val = ~isempty(common_sequence);
end

end


function val = neurons_match(neuron1, neuron2)

val = false;

if length(neuron1)>1
  
  for i=1:length(neuron1)
    
    if neurons_match(neuron1(i), neuron2)
      val = true;
      return
    end
  end
else
  
  tag1 = strrep(neuron1.tag, '"', '');
  tag1 = strrep(tag1, '_', '-');
  tag1 = strrep(tag1, '''', '');
  
  tag2 = strrep(neuron2.tag, '"', '');
  tag2 = strrep(tag2, '_', '-');
  tag2 = strrep(tag2, '''', '');
  
  val = strcmp(neuron1.file_tag, neuron2.file_tag) && ...
    strcmp(neuron1.signal_tag, neuron2.signal_tag) && ...
    strcmp(tag1, tag2);
  
end

end