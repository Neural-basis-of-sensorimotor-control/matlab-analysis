function paired_plot_ic_signal(neuron, pretrigger, posttrigger, outlier_fraction)

if length(neuron)~=1
  
  vectorize_fcn(@paired_plot_ic_signal, neuron, pretrigger, posttrigger, outlier_fraction)
  return
  
end

signal = sc_load_signal(neuron);

v = signal.get_v(true, true, true, true);

trigger = signal.parent.gettriggers(0, inf).get('tag', neuron.template_tag{1});
trigger_times = trigger.gettimes(0, inf);

[sweeps, times] = sc_get_sweeps(v, 0, trigger_times, pretrigger, ...
  posttrigger, signal.dt);

sweeps_filtered = exclude_outliers(sweeps, outlier_fraction);

[~, zero_ind] = min(abs(times));

v_mean = double(mean(sweeps, 2));
v_mean = v_mean - v_mean(zero_ind);

v_median = double(median(sweeps, 2));
v_median = v_median - v_median(zero_ind);

v_filtered_mean = double(mean(sweeps_filtered, 2));
v_filtered_mean = v_filtered_mean - v_filtered_mean(zero_ind);

if is_double_patch(signal)
  
  neuron2 = neuron.clone();
  
  if strcmp(neuron.signal_tag, 'patch')
    neuron2.signal_tag = 'patch2';
  else
    neuron2.signal_tag = 'patch';
  end    
    
  signal2 = sc_load_signal(neuron2);
  
  v2 = signal2.get_v(true, true, true, true);
  
  sweeps2 = sc_get_sweeps(v2, 0, trigger_times, pretrigger, ...
    posttrigger, signal.dt);
  
  v2_mean = double(mean(sweeps2, 2));  
  v2_mean = v2_mean - v2_mean(zero_ind);
  v2_mean = v2_mean * max(v_mean) / max(v2_mean);
else
  
  v2_mean = [];
  
end

incr_fig_indx();
clf

%subplot(2,1,1)
hold on

if ~isempty(v2_mean)

  plot(times, v2_mean, 'Color', 'r', 'Tag', neuron2.signal_tag);

end

plot(times, v_filtered_mean, 'LineWidth', 2, 'Color', 'b', 'Tag', neuron.signal_tag)
plot(times, v_median, 'Color', 'y', 'Tag', neuron.signal_tag);
plot(times, v_mean, 'LineWidth', 1, 'Color', 'g', 'Tag', neuron.signal_tag)

hold off

legend_str = {[neuron.signal_tag , ' IC mean selected'], [neuron.signal_tag , ' IC median all'], [neuron.signal_tag , ' IC mean all']};

if ~isempty(v2_mean)

  legend_str(2:end+1) = legend_str;
  legend_str(1) = {[neuron2.signal_tag ' mean all (scaled)']};
  
end

legend(legend_str{:});

title(sprintf('%s (%s) N = %d', neuron.file_tag, neuron.signal_tag, size(sweeps, 2)));
xlabel('time [s]')
ylabel('voltage [mV]');

subplot(2,1,2)

hold on

for i=1:size(sweeps, 2)
  plot(times, sweeps(:,i) -  sweeps(zero_ind,i));  
end

hold off

end


function val = is_double_patch(signal)

val = list_contains(signal.parent.signals.list, 'tag', 'patch') && ...
  list_contains(signal.parent.signals.list, 'tag', 'patch2');

end
