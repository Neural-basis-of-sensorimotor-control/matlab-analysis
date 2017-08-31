function paired_perispike(neuron, pretrigger, posttrigger, binwidth, ...
  min_stim_latency, max_stim_latency)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_perispike, neuron, pretrigger, posttrigger, binwidth, ...
    min_stim_latency, max_stim_latency);
  
  return
  
end

[t1, t2] = paired_get_neuron_spiketime(neuron);

stim_times = paired_get_stim_times(neuron);
stim_times = cell2mat(stim_times');

incr_fig_indx();
clf

h1 = subplot(1, 2, 1);
plot_perispike(t1, t2, stim_times, pretrigger, posttrigger, binwidth, ...
  min_stim_latency, max_stim_latency, neuron.template_tag{1});

h2 = subplot(1, 2, 2);
plot_perispike(t2, t1, stim_times, pretrigger, posttrigger, binwidth, ...
  min_stim_latency, max_stim_latency, neuron.template_tag{2});

linkaxes([h1 h2])

paired_add_neuron_textbox(neuron);

end


function plot_perispike(presynaptic_spikes, postsynaptic_spikes, stim_times, ...
  pretrigger, posttrigger, binwidth, min_stim_latency, max_stim_latency, ...
  presynaptic_tag)

[presynaptic_spikes_stim, presynaptic_spikes_spont] = ...
  paired_single_out_spont_spikes(presynaptic_spikes,  stim_times, ...
  min_stim_latency, max_stim_latency);

hold on

[~, ~, h] = sc_perihist(presynaptic_spikes, postsynaptic_spikes, pretrigger, posttrigger, binwidth);
set(h, 'Tag', sprintf('all sweeps         (N = %d)', length(presynaptic_spikes)));

[~, ~, h] = sc_perihist(presynaptic_spikes_stim, postsynaptic_spikes, pretrigger, posttrigger, binwidth);
set(h, 'Tag', sprintf('post stim sweeps   (N = %d)', length(presynaptic_spikes_stim)));

[~, ~, h] = sc_perihist(presynaptic_spikes_spont, postsynaptic_spikes, pretrigger, posttrigger, binwidth);
set(h, 'Tag', sprintf('spontaneous sweeps (N = %d)', length(presynaptic_spikes_spont)));

hold off
grid on

xlabel('Time [ms]')
ylabel('Activity [Hz]')

title(sprintf('trigger: %s', presynaptic_tag))

add_legend();

end