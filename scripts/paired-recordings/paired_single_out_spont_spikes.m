function [stim_spike_times, spont_spike_times] = ...
  paired_single_out_spont_spikes(spike_times, stim_times, ...
  min_stim_latency, max_stim_latency)

ind_stimulation = arrayfun(@(x) any(x > stim_times + min_stim_latency & ...
  x < stim_times + max_stim_latency), spike_times);

stim_spike_times   = spike_times(ind_stimulation);
spont_spike_times  = spike_times(~ind_stimulation);

end