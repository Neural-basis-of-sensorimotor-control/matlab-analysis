function paired_conditional_isi(neuron, min_stim_latency, max_stim_latency, ...
  min_spike_latency, max_spike_latency, binwidth, tmax)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_conditional_isi, neuron, min_stim_latency, ...
    max_stim_latency, min_spike_latency, max_spike_latency, binwidth, tmax);
  return
  
end

[t1_all, t2_all] = paired_get_neuron_spiketime(neuron);

stim_times = paired_get_stim_times(neuron);
stim_times = cell2mat(stim_times');

[t1_stim, t1_spont] = paired_single_out_spont_spikes(t1_all, stim_times, ...
  min_stim_latency, max_stim_latency);

[t2_stim, t2_spont] = paired_single_out_spont_spikes(t2_all, stim_times, ...
  min_stim_latency, max_stim_latency);

incr_fig_indx();
clf

h1 = subplot(2, 3, 1);
plot_conditional_isi(t1_all, t2_all, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, 'all sweeps', neuron, neuron.template_tag{1});

h2 = subplot(2, 3, 2);
plot_conditional_isi(t1_stim, t2_all, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, 'post stim sweeps', neuron, neuron.template_tag{1});

h3 = subplot(2, 3, 3);
plot_conditional_isi(t1_spont, t2_all, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, 'spontaneous sweeps', neuron, neuron.template_tag{1});

h4 = subplot(2, 3, 4);
plot_conditional_isi(t2_all, t1_all, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, 'all sweeps', neuron, neuron.template_tag{2});

h5 = subplot(2, 3, 5);
plot_conditional_isi(t2_stim, t1_all, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, 'post stim sweeps', neuron, neuron.template_tag{2});

h6 = subplot(2, 3, 6);
plot_conditional_isi(t2_spont, t1_all, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, 'spontaneous sweeps', neuron, neuron.template_tag{2});

linkaxes([h1 h2 h3 h4 h5 h6])

txt = annotation('textbox', 'String', neuron.comment);

setx(txt, .02)
sety(txt, .9)

end


function plot_conditional_isi(presynaptic_spiketimes, ...
  postsynaptic_spiketimes, min_spike_latency, max_spike_latency, ...
  binwidth, tmax, selection_str, neuron, trigger_str)

postsynaptic_spiketimes = sort(postsynaptic_spiketimes);

ind_is_preceeded = arrayfun(@(x) ...
  any(x > presynaptic_spiketimes + min_spike_latency & ...
  x < presynaptic_spiketimes + max_spike_latency), postsynaptic_spiketimes);

postsynaptic_spiketimes_triggered = ...
  postsynaptic_spiketimes(ind_is_preceeded);

postsynaptic_spiketimes_nontriggered = ...
  postsynaptic_spiketimes(~ind_is_preceeded);

[isi_all, bintimes, n_all]            = sc_latency_distribution(...
  postsynaptic_spiketimes, postsynaptic_spiketimes, binwidth, tmax);

[isi_triggered, ~, n_triggered]       = sc_latency_distribution(...
  postsynaptic_spiketimes_triggered, postsynaptic_spiketimes, binwidth, tmax);

[isi_nontriggered, ~, n_nontriggered] = sc_latency_distribution(...
  postsynaptic_spiketimes_nontriggered, postsynaptic_spiketimes, binwidth, tmax);

hold on

plot(bintimes, isi_all,          'Tag', sprintf('all spikes           N = %d', n_all))
plot(bintimes, isi_triggered,    'Tag', sprintf('triggered spikes     N = %d', n_triggered))
plot(bintimes, isi_nontriggered, 'Tag', sprintf('non-triggered spikes N = %d', n_nontriggered))

hold off

add_legend();
grid on

xlabel('ISI time [s]')
ylabel('Relative frequency')

title(sprintf('%s %s %s: %s', neuron.file_tag, neuron.signal_tag, ...
  selection_str, trigger_str));

end









