function paired_plot_raster(neuron)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_plot_raster, neuron)
  return
  
end


[t1, t2] = paired_get_neuron_spiketime(neuron);

y_lower = 0;
y_upper = 4;

incr_fig_indx();
clf

hold on

plot(t1, ones(size(t1)), '+', t2, 2*ones(size(t2)), '+');

pattern_times = paired_get_pattern_times(neuron);

for j=1:length(pattern_times)
  
  tmp_pattern_time = pattern_times{j};
  plot(tmp_pattern_time, 3*ones(size(tmp_pattern_time)), '+');

end

ylim([y_lower y_upper]);

neuron_tag = neuron.template_tag;
neuron_tag(3) = {'stim_patterns'};
file_tag = neuron.file_tag;

set(gca, 'YTick', 1:length(neuron_tag), 'YTickLabel', neuron_tag, 'TickLabelInterpreter', 'none');
axis_wide(gca, 'y');

ylabel('Neuron');
xlabel('Time (s)');
title(['File: ' file_tag ', ' neuron.template_tag{1} ', ' neuron.template_tag{2}])

hold off

end