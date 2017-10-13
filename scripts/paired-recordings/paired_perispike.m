function paired_perispike(neuron, pretrigger, posttrigger, kernelwidth, ...
  min_stim_latency, max_stim_latency)
%paired_perispike(neuron, pretrigger, posttrigger, kernelwidth, ...
%  min_stim_latency, max_stim_latency)

if length(neuron) ~= 1
  
  vectorize_fcn(@paired_perispike, neuron, pretrigger, posttrigger, kernelwidth, ...
    min_stim_latency, max_stim_latency);
  
  return
  
end

binwidth = 1e-4;

[spiketimes1, spiketimes2] = paired_get_neuron_spiketime(neuron);

stim_times = paired_get_stim_times(neuron);
stim_times = cell2mat(stim_times');

[spiketimes1_stim, spiketimes1_spont] = ...
  paired_single_out_spont_spikes(spiketimes1,  stim_times, ...
  min_stim_latency, max_stim_latency);

[spiketimes2_stim, spiketimes2_spont] = ...
  paired_single_out_spont_spikes(spiketimes2,  stim_times, ...
  min_stim_latency, max_stim_latency);

f = incr_fig_indx();
clf

title_str = [neuron.file_tag ' ' neuron.template_tag{1} ' ' neuron.template_tag{2}];

f.Name = title_str;

h1 = subplot(3, 2, 1);
plot_perispike(spiketimes1, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [neuron.file_tag ', trigger: ' neuron.template_tag{1}]);

h2 = subplot(3, 2, 2);
plot_perispike(spiketimes2, spiketimes1, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [neuron.file_tag ', trigger: ' neuron.template_tag{2}]);

h3 = subplot(3, 2, 3);
plot_perispike(spiketimes1_stim, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, ['(STIM) ' neuron.file_tag ', trigger: ' neuron.template_tag{1}]);

h4 = subplot(3, 2, 4);
plot_perispike(spiketimes2_stim, spiketimes1, pretrigger, posttrigger, ...
  kernelwidth, binwidth, ['(STIM) ' neuron.file_tag ', trigger: ' neuron.template_tag{2}]);

h5 = subplot(3, 2, 5);
plot_perispike(spiketimes1_spont, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, ['(SPONT) ' neuron.file_tag ', trigger: ' neuron.template_tag{1}]);

h6 = subplot(3, 2, 6);
plot_perispike(spiketimes2_spont, spiketimes1, pretrigger, posttrigger, ...
  kernelwidth, binwidth, ['(SPONT) ' neuron.file_tag ', trigger: ' neuron.template_tag{2}]);

h_axes = [h1 h2 h3 h4 h5 h6];

linkaxes(h_axes)

neuron.add_load_signal_menu([h1 h3 h5], neuron.template_tag{1});
neuron.add_load_signal_menu([h2 h4 h6], neuron.template_tag{2});

incr_fig_indx()
clf

subplot(211)
plot_perispike(spiketimes1, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [neuron.file_tag ', trigger: ' neuron.template_tag{1}], 'all');
plot_perispike(spiketimes1_stim, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [], 'stim');
plot_perispike(spiketimes1_spont, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [], 'spont');
add_legend();

title_str = [neuron.file_tag ' trigger: ' neuron.template_tag{2} ' triggered: ' neuron.template_tag{1}];
title(gca, title_str);

subplot(212)
plot_perispike(spiketimes2, spiketimes1, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [neuron.file_tag ', trigger: ' neuron.template_tag{2}], 'all');
plot_perispike(spiketimes2_stim, spiketimes1, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [], 'stim');
plot_perispike(spiketimes2_spont, spiketimes1, pretrigger, posttrigger, ...
  kernelwidth, binwidth, [], 'spont');
add_legend();

title_str = [neuron.file_tag ' trigger: ' neuron.template_tag{2} ' triggered: ' neuron.template_tag{1}];
title(gca, title_str);

end


function plot_perispike(spiketimes1, spiketimes2, pretrigger, posttrigger, ...
  kernelwidth, binwidth, str_title, tag)

hold on

if ~exist('tag', 'var')
  sc_kernelhist(spiketimes1, spiketimes2, pretrigger, posttrigger, kernelwidth, binwidth);
end

[~, ~, h_plot_2] = sc_kernelhist(spiketimes1, spiketimes2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
set(h_plot_2, 'LineWidth', 2, 'Color', 'b');

if ~isempty(str_title)
  title(sprintf('%s N = %d', str_title, length(spiketimes1)));
  ylabel('Freq [Hz]')
  xlabel('Time [s]')
  grid on
end

if exist('tag', 'var')
  set(h_plot_2, 'Tag', tag);
end

end

