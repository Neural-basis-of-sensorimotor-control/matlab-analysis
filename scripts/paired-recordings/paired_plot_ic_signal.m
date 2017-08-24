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


sweeps_contain_xpsp  = match_template(signal, sweeps, sweep_times, t_range, neuron.xpsp_tag);

if isempty(neuron.xpsp_tag)
  sweeps_contain_xpsp = true(size(sweeps_contain_xpsp));
end

sweeps_contain_spike = match_template(signal, sweeps, sweep_times, [min(t_range(1), 0) t_range(2)], neuron.artifact_tag);

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
  ['Mean   (EPSP), N = '            num2str(size(xpsp_sweeps, 2))],         'Median (EPSP)'
  ['Mean   (dendritic spike), N = ' num2str(size(spike_sweeps, 2))],        'Median (dendritic spike)'
  ['Mean   (antiselected), N = '    num2str(size(antiselected_sweeps, 2))], 'Median (antiselected)'
  };

subplot(211)
hold on

plot(sweep_times, mean(xpsp_sweeps, 2),   'LineStyle', '-',  'LineWidth', 2, 'Color', colors(1, :))
plot(sweep_times, median(xpsp_sweeps, 2), 'LineStyle', '--', 'LineWidth', 2, 'Color', colors(2, :))

plot(sweep_times, mean(spike_sweeps, 2),   'LineStyle', '-',  'Color', colors(3, :))
plot(sweep_times, median(spike_sweeps, 2), 'LineStyle', '--', 'Color', colors(4, :))

plot(sweep_times, mean(antiselected_sweeps, 2),   'LineStyle', '-',   'Color', colors(5, :))
plot(sweep_times, median(antiselected_sweeps, 2), 'LineStyle', '--',  'Color', colors(6, :))

legend(legend_str);

title_str = sprintf('%s - %s (%s) comment: %s', neuron.file_tag, neuron.signal_tag, neuron.template_tag{1}, neuron.comment);

title(title_str, 'Interpreter', 'none');

xlabel('time [s]')
ylabel('voltage [mV]');

grid on

subplot(212)
hold on




plot(sweep_times, mean(xpsp_sweeps, 2),   'LineStyle', '-',  'LineWidth', 2, 'Color', colors(1, :))
plot(sweep_times, median(xpsp_sweeps, 2), 'LineStyle', '--', 'LineWidth', 2, 'Color', colors(2, :))

plot(sweep_times, mean(spike_sweeps, 2),   'LineStyle', '-',  'Color', colors(3, :))
plot(sweep_times, median(spike_sweeps, 2), 'LineStyle', '--', 'Color', colors(4, :))

plot(sweep_times, mean(antiselected_sweeps, 2),   'LineStyle', '-',   'Color', colors(5, :))
plot(sweep_times, median(antiselected_sweeps, 2), 'LineStyle', '--',  'Color', colors(6, :))

legend(legend_str);

end


function is_match = match_template(signal, sweeps, sweep_times, t_range, templates)

is_match = false(1, size(sweeps,2));

for i=1:length(templates)
  
  template = signal.parent.gettriggers(0, inf).get('tag', templates{i});
  
  for j=1:size(sweeps, 2)
    
    template_times = sweep_times(template.match_v(sweeps(:,j)));
    
    if ~is_match(j)
      
      is_match(j) = any(template_times > t_range(1) & template_times < t_range(2));
      
    end
  end
end

end


function [mean_sweeps, median_sweeps, confidence_width_sweeps] = get_mean(sweeps)

p = .05;
alpha = tinv(1-p, size(sweeps, 2)-1);

mean_sweeps   = mean(sweeps, 2);
median_sweeps = median(sweeps, 2);
confidence_width_sweeps = 

alpha(i)*std_avg_response/sqrt(length(neurons)
end
