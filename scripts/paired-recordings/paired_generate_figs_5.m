clc
close all
clear

sc_settings.set_current_settings_tag(sc_settings.tags.DEFAULT);
sc_debug.set_mode(true);

neurons = paired_get_extra_neurons();
stim_freq = nan(2*length(neurons), 1);
spont_freq = nan(2*length(neurons), 1);
stim_duration = 4e-2;

for i=1:length(neurons)
  sc_debug.print(i, length(neurons));
  [t1, t2] = paired_get_neuron_spiketime(neurons(i));
  start_times = paired_get_stim_times(neurons(i), get_patterns());
  start_times = sort(cell2mat(start_times'));
  start_times(start_times< neurons(i).tmin | start_times>neurons(i).tmax) = [];
  start_times(start_times < min(t1) | start_times < min(t2)) = [];
  start_times(start_times > max(t1) | start_times > max(t2)) = [];
  start_times(diff(start_times)<stim_duration) = []; 
  tot_stim_duration = stim_duration*length(start_times);
  tot_spont_duration = start_times(end)+stim_duration - start_times(1) - tot_stim_duration;
  
  t1(t1 < start_times(1) | t1 > start_times(end) + stim_duration) = [];
  t2(t2 < start_times(1) | t2 > start_times(end) + stim_duration) = [];
  [stim_spike_times_1, spont_spike_times_1] = ...
    paired_single_out_spont_spikes(t1, start_times, 0, stim_duration);
  stim_freq(i*2-1)  = length(stim_spike_times_1)/tot_stim_duration;
  spont_freq(i*2-1) = length(spont_spike_times_1)/tot_spont_duration;
  
  [stim_spike_times_2, spont_spike_times_2] = ...
    paired_single_out_spont_spikes(t2, start_times, 0, stim_duration);
  stim_freq(i*2)  = length(stim_spike_times_2)/tot_stim_duration;
  spont_freq(i*2) = length(spont_spike_times_2)/tot_spont_duration;
  
end

incr_fig_indx
clf
hold on
plot(stim_freq, spont_freq, '+')
xlabel('Stim freq (Hz)')
ylabel('Spont freq (Hz)')
grid on
axis equal
xl = xlim;
yl = ylim;
xlim([0 max([xl yl])])
ylim([0 max([xl yl])])
plot(xlim, xlim, 'k')