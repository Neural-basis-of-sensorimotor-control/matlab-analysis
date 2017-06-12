function [val, neg_normalization] = get_onset_latency_abs(amplitude)

val = mean(amplitude.get_latency(0));

neg_normalization = false;

end
