function plot_raster_paired_recordings(overlapping_neuron, time_sequence, ...
  title_addition)

if isa(overlapping_neuron, 'List')
  
  for i=1:len(overlapping_neuron)
    
    plot_raster_paired_recordings(overlapping_neuron(i), time_sequence{i}, ...
      title_addition);
  end
  
  return
end

[t1, t2] = get_paired_neurons_spiketimes(overlapping_neuron);

y_lower = 0;
y_upper = 4;

incr_fig_indx();
hold on


for j=1:size(time_sequence, 1)
  xleft = time_sequence(j, 1);
  xright = time_sequence(j, 2);
  patch([xleft xleft xright xright], [y_lower y_upper y_upper y_lower], .95*[1 1 1])
end

plot(t1, ones(size(t1)), '+', t2, 2*ones(size(t2)), '+');

if isa(overlapping_neuron, 'ScNeuron')
  pattern_times = get_pattern_times(overlapping_neuron);
end

for j=1:length(pattern_times)
  tmp_pattern_time = pattern_times{j};
  plot(tmp_pattern_time, 3*ones(size(tmp_pattern_time)), '+');
end

ylim([y_lower y_upper]);

if isa(overlapping_neuron, 'ScSpikeTrainCluster')
  neuron_tag = {overlapping_neuron.neurons.tag};
  file_tag = overlapping_neuron.neurons(1).file_tag;
elseif isa(overlapping_neuron, 'ScNeuron')
  neuron_tag = overlapping_neuron.template_tag;
  neuron_tag(3) = {'stim_patterns'};
  file_tag = overlapping_neuron.file_tag;
elseif isstruct(overlapping_neuron)
  neuron_tag = overlapping_neuron.neuron1.tag;
  file_tag = overlapping_neuron.neuron1.file_tag;
else
  error('Function not defined for input %s', class(overlapping_neuron));
end

set(gca, 'YTick', 1:length(neuron_tag), 'YTickLabel', neuron_tag, 'TickLabelInterpreter', 'none');
axis_wide(gca, 'y');

ylabel('Neuron');
xlabel('Time (s)');
title(['File: ' file_tag ', ' title_addition])
