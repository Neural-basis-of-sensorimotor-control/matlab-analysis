function [params_ci, depth, tag] = paired_bootstrap_params(neuron, reverse)

nbr_of_bootstrap_iterations = 100;

tag = {neuron.file_tag};
depths = paired_parse_for_subcortical_depth(neuron);
if strcmp(neuron.protocol_signal_tag, 'patch') || strcmp(neuron.protocol_signal_tag, 'patch1')
  depth = depths.depth1;
elseif strcmp(neuron.protocol_signal_tag, 'patch2')
  depth = depths.depth2;
else
  error('Unknown tag: %s', neuron.protocol_signal_tag);
end

[t1, t2] = paired_get_neuron_spiketime(neuron);
params = nan(6, nbr_of_bootstrap_iterations);

for i=1:nbr_of_bootstrap_iterations
  if reverse
    params(:, i) = bootstrap_fcn(t2, t1);
  else
    params(:, i) = bootstrap_fcn(t1, t2);
  end
end

ts = tinv([0.025  0.975], nbr_of_bootstrap_iterations-1);
params_ci = nan(size(params, 1), 2);
for i=1:length(params_ci)
  params_ci(i, :) = mean(params(i, :)) + std(params(i, :))/nbr_of_bootstrap_iterations * ts;
end

end

function params = bootstrap_fcn(t1_original, t2)

window_width = 4;
pretrigger  = -window_width/2;
posttrigger = window_width/2;
kernelwidth = 1e-3;
binwidth    = 1e-3;

bootstrap_indx = randi(length(t1_original), length(t1_original), 1);
t1 = t1_original(bootstrap_indx);

[lowpass_freq, lowpass_t] = sc_kernelhist(true, t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
highpass_freq             = sc_kernelhist(true, t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);

avg_freq = mean(lowpass_freq((lowpass_t>pretrigger+.2 & lowpass_t < -.5) | (lowpass_t>.5 & lowpass_t < posttrigger-.2)));

param_indx = nan(7, 1);

param_indx(3) = find(lowpass_freq < avg_freq & lowpass_t < 0, 1, 'last');
param_indx(1) = find(lowpass_freq > avg_freq & lowpass_t < lowpass_t(param_indx(3)), 1, 'last');
[~, param_indx(2)] = min(lowpass_freq(param_indx(1):param_indx(3)));
param_indx(2) = param_indx(2) + param_indx(1) - 1;

param_indx(5) = find(lowpass_freq < avg_freq & lowpass_t > 0, 1, 'first');
[~, param_indx(4)] = max(highpass_freq(param_indx(3):param_indx(5)));
param_indx(4) = param_indx(4) + param_indx(3) - 1;

param_indx(7) = find(lowpass_freq > avg_freq & lowpass_t > lowpass_t(param_indx(5)), 1, 'first');
[~, param_indx(6)] = min(lowpass_freq(param_indx(5):param_indx(7)));
param_indx(6) = param_indx(6) + param_indx(5) - 1;

params = [
  lowpass_t(param_indx(2))
  (lowpass_freq(param_indx(2)) - .5*(lowpass_freq(param_indx(1)) + lowpass_freq(param_indx(3))))/avg_freq;
  
  lowpass_t(param_indx(4))
  (highpass_freq(param_indx(4)) - .5*(lowpass_freq(param_indx(3)) + lowpass_freq(param_indx(5))))/avg_freq;
  
  lowpass_t(param_indx(6))
  (lowpass_freq(param_indx(6)) - .5*(lowpass_freq(param_indx(5)) + lowpass_freq(param_indx(7))))/avg_freq;
  ];

end