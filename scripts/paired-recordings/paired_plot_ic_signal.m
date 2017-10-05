function paired_plot_ic_signal(neuron, pretrigger, posttrigger, t_epsp_range, t_spike_range, max_isi_double_trigger)

if length(neuron)~=1
  
  vectorize_fcn(@paired_plot_ic_signal, neuron, pretrigger, posttrigger, t_epsp_range, t_spike_range, max_isi_double_trigger);
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

sweeps_contain_xpsp  = paired_match_template(signal, sweeps, sweep_times, t_epsp_range, neuron.xpsp_tag);

if isempty(neuron.xpsp_tag)
  sweeps_contain_xpsp = true(size(sweeps_contain_xpsp));
end

sweeps_contain_spike = paired_match_template(signal, sweeps, sweep_times, t_spike_range, neuron.artifact_tag);

xpsp_sweeps         = sweeps(:, sweeps_contain_xpsp & ~sweeps_contain_spike);
%spike_sweeps        = sweeps(:, sweeps_contain_spike);
antiselected_sweeps = sweeps(:, ~sweeps_contain_xpsp & ~sweeps_contain_spike);

[mean_xpsp, median_xpsp, confidence_width_xpsp] = ...
  get_mean(xpsp_sweeps);
% [mean_spike, median_spike, ~] = ...
%   get_mean(spike_sweeps);
[mean_antiselected, median_antiselected, confidence_width_antiselected] = ...
  get_mean(antiselected_sweeps);


fig = incr_fig_indx();
clf

colors = varycolor(6);

legend_str = {
  ['Mean   (EPSP), N = ' num2str(size(xpsp_sweeps, 2))]
  'Median (EPSP)'
%   ['Mean   (dendritic spike), N = ' num2str(size(spike_sweeps, 2))]
%   'Median (dendritic spike)'
  ['Mean   (antiselected), N = ' num2str(size(antiselected_sweeps, 2))]
  'Median (antiselected)'
  };

% %ax1 = subplot(211);
% ax1 = gca;
% neuron.add_load_signal_menu(ax1, neuron.template_tag{1});
% 
% hold on
% 
% plot(sweep_times, mean_xpsp,   'LineStyle', '-',  'LineWidth', 2, 'Color', colors(1, :))
% plot(sweep_times, median_xpsp, 'LineStyle', '--', 'LineWidth', 2, 'Color', colors(2, :))
% 
% %plot(sweep_times, mean_spike,   'LineStyle', '-',  'Color', colors(3, :))
% %plot(sweep_times, median_spike, 'LineStyle', '--', 'Color', colors(4, :))
% 
% plot(sweep_times, mean_antiselected,   'LineStyle', '-',   'Color', colors(5, :))
% plot(sweep_times, median_antiselected, 'LineStyle', '--',  'Color', colors(6, :))
% 
% legend(legend_str);
% 
title_str = sprintf('%s - %s (%s) comment: %s', neuron.file_tag, neuron.signal_tag, neuron.template_tag{1}, neuron.comment);
% 
% title(title_str, 'Interpreter', 'none');
% 
% xlabel('time [s]')
% ylabel('voltage [mV]');
% 
% grid on

fig = incr_fig_indx();
clf
%ax2 = subplot(212);
ax2 = gca;
neuron.add_load_signal_menu(ax2, neuron.template_tag{1});

hold on

plot(sweep_times, mean_xpsp,           'LineStyle', '-', 'LineWidth', 2, 'Color', colors(1, :))
plot(sweep_times, mean_antiselected,   'LineStyle', '-', 'LineWidth', 2, 'Color', colors(5, :))

legend_str = {'Mean +/- percentiles (EPSP)' %+/- confidence bounds (EPSP)'
  'Mean +/- percentiles (unselected)' %+/- confidence bounds (antiselected)'
  };

legend(legend_str)

[lower_xpsp, upper_xpsp] = get_percentile(xpsp_sweeps);
plot(sweep_times, lower_xpsp,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(1, :))
plot(sweep_times, upper_xpsp,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(1, :))

[lower_antiselected, upper_antiselected] = get_percentile(antiselected_sweeps);

plot(sweep_times, lower_antiselected,   'LineStyle', '--',  'LineWidth', 1, 'Color', colors(5, :))
plot(sweep_times, upper_antiselected,   'LineStyle', '--',   'LineWidth', 1, 'Color', colors(5, :))

title(title_str, 'Interpreter', 'none');

xlabel('time [s]')
ylabel('voltage [mV]');

%grid on

%linkaxes([ax1 ax2], 'x')

fig.Name = title_str;

return
[v_single, v_first, v_second, v_middle] = paired_detect_double_trigger(...
  signal, xpsp_sweeps, sweep_times, neuron.template_tag{1}, max_isi_double_trigger);

incr_fig_indx();
clf

subplot(2, 2, 1)
plot_sweeps(sweep_times, v_single, [neuron.file_tag ' single trigger']);

subplot(2, 2, 2)
plot_sweeps(sweep_times, v_first, [neuron.file_tag ' first trigger']);

subplot(2, 2, 3)
plot_sweeps(sweep_times, v_second, [neuron.file_tag ' second trigger']);

subplot(2, 2, 4)
plot_sweeps(sweep_times, v_middle, [neuron.file_tag ' middle trigger']);

incr_fig_indx();
clf

hold on
[mean_single, ~, confidence_width_single] = get_mean(v_single);
[mean_second, ~, confidence_width_second] = get_mean(v_second);

tag = ['single, N = ' num2str(size(v_single, 2))];
plot(sweep_times, mean_single,                             'LineStyle', '-',   'LineWidth', 2, 'Tag', tag)
plot(sweep_times, mean_single + confidence_width_single,   'LineStyle', '-',  'LineWidth', 1, 'Tag', tag)
plot(sweep_times, mean_single - confidence_width_single,   'LineStyle', '-',  'LineWidth', 1, 'Tag', tag)

tag = ['second, N = ' num2str(size(v_second, 2))];
plot(sweep_times, mean_second,                             'LineStyle', '-',   'LineWidth', 2, 'Tag', tag)
plot(sweep_times, mean_second + confidence_width_second,   'LineStyle', '-',  'LineWidth', 1, 'Tag', tag)
plot(sweep_times, mean_second - confidence_width_second,   'LineStyle', '-',  'LineWidth', 1, 'Tag', tag)

add_legend

end


function [mean_sweeps, median_sweeps, confidence_width_sweeps] = get_mean(sweeps)

p = .05;
alpha = tinv(1-p/2, size(sweeps, 2)-1);

mean_sweeps   = mean(sweeps, 2);
median_sweeps = median(sweeps, 2);
confidence_width_sweeps = alpha*std(sweeps, 0, 2)/sqrt(size(sweeps, 2));

end


function [lower, upper] = get_percentile(sweeps)

lower = prctile(sweeps', 25);
upper = prctile(sweeps', 75);

end


function plot_sweeps(sweep_times, sweeps, str_title)

hold on
for i=1:size(sweeps, 2)
  plot(sweep_times, sweeps(:, i))
end

title([str_title ', N = ' num2str(size(sweeps, 2))]);

end
