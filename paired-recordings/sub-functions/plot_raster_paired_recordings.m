function plot_raster_paired_recordings(overlapping_neurons)

for i=1:len(overlapping_neurons)
  overlapping_neuron = overlapping_neurons(i);
  
  [t1, t2] = get_paired_neurons_spiketimes(overlapping_neuron);
  
  y_lower = 0;
  y_upper = 3;
  
  incr_fig_indx();
  hold on
  
  for j=1:size(overlapping_neuron.time_sequences, 1)
    xleft = overlapping_neuron.time_sequences(j, 1);
    xright = overlapping_neuron.time_sequences(j, 2);
    patch([xleft xleft xright xright], [y_lower y_upper y_upper y_lower], .95*[1 1 1])
  end
  
  plot(t1, ones(size(t1)), '+', t2, 2*ones(size(t2)), '+');
  ylim([y_lower y_upper]);

  set(gca, 'YTick', [1 2], 'YTickLabel', ...
    {overlapping_neuron.neuron1.tag, overlapping_neuron.neuron2.tag}, ...
    'TickLabelInterpreter', 'none');
  ylabel('Neuron');
  xlabel('Time (ms)');
  title(['File: ' overlapping_neuron.neuron1.file_tag])
end