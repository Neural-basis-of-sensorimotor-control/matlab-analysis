

function [val, neg_normalization] = get_epsp_width_abs(amplitude)

val = mean(amplitude.get_width(0));

neg_normalization = false;

end
