function paired_plot_ic_signal(neuron, pretrigger, posttrigger, outlier_fraction)

if length(neuron)~=1
  
  vectorize_fcn(@paired_plot_ic_signal, neuron, pretrigger, posttrigger, outlier_fraction)
  return
  
end

if ~isempty(neuron.ic_fcn)
  
  neuron0 = neuron.clone();
  neuron0.ic_fcn = {};
  
  raw_sweeps = paired_get_sweeps(neuron0, pretrigger, posttrigger);
  v0_mean    = mean(raw_sweeps, 2);
  
else
  v0_mean = [];
end

[sweeps, sweep_times, signal] = paired_get_sweeps(neuron, pretrigger, posttrigger);

if isempty(sweeps)
  fprintf('Skipping %s because no sweeps\n', neuron.file_tag);
  return
end

[~, zero_ind] = min(abs(sweep_times));

for i=1:size(sweeps, 2)
  sweeps(:,i) = sweeps(:,i) - sweeps(zero_ind, i);
end

sweeps_filtered = exclude_outliers(sweeps, outlier_fraction);

incr_fig_indx()
clf
hold on

for i=1:size(sweeps, 2)
  plot(sweep_times, sweeps(:,i)')
end

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
  
  neuron2.ic_fcn = {};
  sweeps2 = paired_get_sweeps(neuron2, pretrigger, posttrigger);
  
  v2_mean = double(mean(sweeps2, 2));  
  v2_mean = v2_mean - v2_mean(zero_ind);
  v2_mean = v2_mean * max(v_mean) / max(v2_mean);
else
  
  v2_mean = [];
  
end

incr_fig_indx();
clf

hold on

plot(sweep_times, v_filtered_mean, 'LineWidth', 2, 'Color', 'b')
plot(sweep_times, v_median, 'Color', 'y');
plot(sweep_times, v_mean, 'LineWidth', 1, 'Color', 'g')

legend_str = {[neuron.signal_tag , ' IC mean selected'], [neuron.signal_tag , ' IC median all'], [neuron.signal_tag , ' IC mean all']};

if ~isempty(v2_mean)

  plot(sweep_times, v2_mean, 'Color', 'r');
  legend_str(end+1) = {[neuron2.signal_tag ' mean all (scaled)']};
end

if ~isempty(v0_mean)
  
  plot(sweep_times, v0_mean, 'Color', 'k');
  legend_str(end+1) = {[neuron.signal_tag ' mean all (raw data)']};
end

hold off

legend(legend_str{:});

title_str = sprintf('%s (%s) N = %d', neuron.file_tag, neuron.template_tag{1}, size(sweeps, 2));

for i=1:length(neuron.ic_fcn)
  
  str = char(neuron.ic_fcn{i});
  
  title_str = [title_str ' ' str]; %#ok<AGROW>
  
end

title(title_str, 'Interpreter', 'none');

xlabel('time [s]')
ylabel('voltage [mV]');

end

