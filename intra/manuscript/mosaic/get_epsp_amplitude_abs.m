

function [val, neg_normalization] = get_epsp_amplitude_abs(amplitude)

val = mean(amplitude.height);

neg_normalization = false;

end
