function plot_raster_paired_recordings(paired_neurons)

for i=1:length(paired_neurons)
  paired_neuron = paired_neurons(i);
  
  [t1, t2] = get_paired_neurons_spiketimes(paired_neuron);
  
  y_lower = 0;
  y_upper = 3;
  
  incr_fig_indx();
  hold on
  
  for j=1:size(paired_neuron.time_sequences, 1)
    xleft = paired_neuron.time_sequences(j, 1);
    xright = paired_neuron.time_sequences(j, 2);
    patch([xleft xleft xright xright], [y_lower y_upper y_upper y_lower], .95*[1 1 1])
  end
  
  plot(t1, ones(size(t1)), '+', t2, 2*ones(size(t2)), '+');
  ylim([y_lower y_upper]);

  set(gca, 'YTick', [1 2], 'YTickLabel', paired_neuron.template_tag);
  ylabel('Neuron');
  xlabel('Time (ms)');
  title(['File: ' paired_neuron.file_tag])
end