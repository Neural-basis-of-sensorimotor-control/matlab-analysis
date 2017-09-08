function paired_perispike(neuron, pretrigger, posttrigger, kernelwidth, ...
  min_stim_latency, max_stim_latency)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_perispike, neuron, pretrigger, posttrigger, kernelwidth, ...
    min_stim_latency, max_stim_latency);
  
  return
  
end

[t1, t2] = paired_get_neuron_spiketime(neuron);

stim_times = paired_get_stim_times(neuron);
stim_times = cell2mat(stim_times');

incr_fig_indx();
clf

h1 = subplot(1, 2, 1);
plot_perispike(t1, t2, stim_times, pretrigger, posttrigger, kernelwidth, ...
  min_stim_latency, max_stim_latency, neuron.template_tag{1}, neuron);

h2 = subplot(1, 2, 2);
plot_perispike(t2, t1, stim_times, pretrigger, posttrigger, kernelwidth, ...
  min_stim_latency, max_stim_latency, neuron.template_tag{2}, neuron);

linkaxes([h1 h2])

paired_add_neuron_textbox(neuron);

end


function plot_perispike(presynaptic_spikes, postsynaptic_spikes, stim_times, ...
  pretrigger, posttrigger, kernelwidth, min_stim_latency, max_stim_latency, ...
  presynaptic_tag, neuron)

binwidth = 1e-4;

[presynaptic_spikes_stim, presynaptic_spikes_spont] = ...
  paired_single_out_spont_spikes(presynaptic_spikes,  stim_times, ...
  min_stim_latency, max_stim_latency);

hold on

[f_all, ~, h] = sc_kernelhist(presynaptic_spikes, postsynaptic_spikes, pretrigger, posttrigger, kernelwidth, binwidth);
set(h, 'Tag', sprintf('all sweeps         (N = %d)', length(presynaptic_spikes)), ...
  'LineStyle', '-', 'LineWidth', 2);

plot(xlim, mean(f_all)*[1 1], 'LineWidth', 4)

[f_poststim, ~, h] = sc_kernelhist(presynaptic_spikes_stim, postsynaptic_spikes, pretrigger, posttrigger, kernelwidth, binwidth);
set(h, 'Tag', sprintf('post stim sweeps   (N = %d)', length(presynaptic_spikes_stim)), ...
  'LineStyle', '-', 'LineWidth', 1);

plot(xlim, mean(f_poststim)*[1 1], 'LineWidth', 4)

[f_spont, ~, h] = sc_kernelhist(presynaptic_spikes_spont, postsynaptic_spikes, pretrigger, posttrigger, kernelwidth, binwidth);
set(h, 'Tag', sprintf('spontaneous sweeps (N = %d)', length(presynaptic_spikes_spont)), ...
  'LineStyle', '--', 'LineWidth', 1);

plot(xlim, mean(f_spont)*[1 1], 'LineWidth', 4)

hold off
grid on

xlabel('Time [ms]')
ylabel('Activity [Hz]')

title(sprintf('%s %s trigger: %s', neuron.file_tag, neuron.signal_tag, presynaptic_tag))

add_legend();

end