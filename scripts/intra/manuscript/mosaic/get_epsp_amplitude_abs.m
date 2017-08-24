function [val, neg_normalization] = get_epsp_amplitude_abs(amplitude)

val = mean(amplitude.get_amplitude_height(0));

neg_normalization = false;

end
