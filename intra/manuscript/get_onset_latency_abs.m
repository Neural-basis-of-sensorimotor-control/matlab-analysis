

function [val, neg_normalization] = get_onset_latency_abs(amplitude)

val = mean(amplitude.latency);

neg_normalization = false;

end
