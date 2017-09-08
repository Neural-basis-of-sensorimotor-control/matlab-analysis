function paired_plot_ic_signal(neuron, pretrigger, posttrigger, t_range)

if length(neuron)~=1
  
  vectorize_fcn(@paired_plot_ic_signal, neuron, pretrigger, posttrigger, t_range)
  return
  
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


sweeps_contain_xpsp  = paired_match_template(signal, sweeps, sweep_times, t_range, neuron.xpsp_tag);

if isempty(neuron.xpsp_tag)
  sweeps_contain_xpsp = true(size(sweeps_contain_xpsp));
end

sweeps_contain_spike = paired_match_template(signal, sweeps, sweep_times, [min(t_range(1), 0) t_range(2)], neuron.artifact_tag);

xpsp_sweeps         = sweeps(:, sweeps_contain_xpsp & ~sweeps_contain_spike);
spike_sweeps        = sweeps(:, sweeps_contain_spike);
antiselected_sweeps = sweeps(:, ~sweeps_contain_xpsp & ~sweeps_contain_spike);

[mean_xpsp, median_xpsp, confidence_width_xpsp] = ...
  get_mean(xpsp_sweeps);
[mean_spike, median_spike, confidence_width_spike] = ...
  get_mean(spike_sweeps);
[mean_antiselected, median_antiselected, confidence_width_antiselected] = ...
  get_mean(antiselected_sweeps);


incr_fig_indx()
clf

colors = varycolor(6);

legend_str = {
  ['Mean   (EPSP), N = ' num2str(size(xpsp_sweeps, 2))]
  'Median (EPSP)'
  ['Mean   (dendritic spike), N = ' num2str(size(spike_sweeps, 2))]
  'Median (dendritic spike)'
  ['Mean   (antiselected), N = ' num2str(size(antiselected_sweeps, 2))]
  'Median (antiselected)'
  };

ax1 = subplot(211);
hold on

plot(sweep_times, mean_xpsp,   'LineStyle', '-',  'LineWidth', 2, 'Color', colors(1, :))
plot(sweep_times, median_xpsp, 'LineStyle', '--', 'LineWidth', 2, 'Color', colors(2, :))

plot(sweep_times, mean_spike,   'LineStyle', '-',  'Color', colors(3, :))
plot(sweep_times, median_spike, 'LineStyle', '--', 'Color', colors(4, :))

plot(sweep_times, mean_antiselected,   'LineStyle', '-',   'Color', colors(5, :))
plot(sweep_times, median_antiselected, 'LineStyle', '--',  'Color', colors(6, :))

legend(legend_str);

title_str = sprintf('%s - %s (%s) comment: %s', neuron.file_tag, neuron.signal_tag, neuron.template_tag{1}, neuron.comment);

title(title_str, 'Interpreter', 'none');

xlabel('time [s]')
ylabel('voltage [mV]');

grid on

ax2 = subplot(212);
hold on

plot(sweep_times, mean_xpsp,           'LineStyle', '-', 'LineWidth', 2, 'Color', colors(1, :))
plot(sweep_times, mean_spike,          'LineStyle', '-', 'LineWidth', 2, 'Color', colors(3, :))
plot(sweep_times, mean_antiselected,   'LineStyle', '-', 'LineWidth', 2, 'Color', colors(5, :))

legend_str = {'Mean +/- confidence bounds (EPSP)'
  'Mean +/- confidence bounds (dendritic spike)'
  'Mean +/- confidence bounds (antiselected)'
  };

legend(legend_str)

plot(sweep_times, mean_xpsp + confidence_width_xpsp,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(1, :))
plot(sweep_times, mean_xpsp - confidence_width_xpsp,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(1, :))

plot(sweep_times, mean_spike + confidence_width_spike,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(3, :))
plot(sweep_times, mean_spike - confidence_width_spike,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(3, :))

plot(sweep_times, mean_antiselected + confidence_width_antiselected,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(5, :))
plot(sweep_times, mean_antiselected - confidence_width_antiselected,   'LineStyle', '--',   'LineWidth', 1, 'Color', colors(5, :))

title(title_str, 'Interpreter', 'none');
paired_add_neuron_textbox(neuron)

xlabel('time [s]')
ylabel('voltage [mV]');

grid on

linkaxes([ax1 ax2], 'x')

end


function [mean_sweeps, median_sweeps, confidence_width_sweeps] = get_mean(sweeps)

p = .05;
alpha = tinv(1-p/2, size(sweeps, 2)-1);

mean_sweeps   = mean(sweeps, 2);
median_sweeps = median(sweeps, 2);
confidence_width_sweeps = alpha*std(sweeps, 0, 2)/sqrt(size(sweeps, 2));

end
