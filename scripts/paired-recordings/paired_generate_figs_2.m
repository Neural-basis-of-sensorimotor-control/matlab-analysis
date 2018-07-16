clc
close all
clear classes

sc_settings.set_current_settings_tag(sc_settings.tags.DEFAULT);
sc_debug.set_mode(true);

ec_neurons = paired_get_extra_neurons();
params = paired_automatic_deflection_detection(ec_neurons);

post_synaptic_activity = nan(size(neurons));
for i=1:length(neurons)
  [t1, t2] = paired_get_neuron_spiketime(neurons(i));
  [~, lowpass_freq, lowpass_t] = ...
    paired_get_automatic_detection(t1, t2, false, true);
  post_synaptic_activity(i) = mean(lowpass_freq(lowpass_t>0));
  pre_synaptic_activity(i) = mean(lowpass_freq(lowpass_t<0));
  tot_synaptic_activity(i) = mean(lowpass_freq());
end

incr_fig_indx
subplot(2,3,1)
plot(params(1)+params(3), post_synaptic_activity, '+');
title('Pretrigger peak time')
subplot(2,3,2)
plot(params(5)+params(7), post_synaptic_activity, '+');
title('Peritrigger peak time')
subplot(2,3,3)
plot(params(9)+params(11), post_synaptic_activity, '+');
title('Posttrigger peak time')

subplot(2,3,4)
plot(params(4), post_synaptic_activity, '+');
title('Pretrigger peak value')
subplot(2,3,5)
plot(params(8), post_synaptic_activity, '+');
title('Peritrigger peak value')
subplot(2,3,6)
plot(params(12), post_synaptic_activity, '+');
title('Posttrigger peak value')


  
