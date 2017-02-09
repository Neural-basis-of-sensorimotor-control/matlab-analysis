

function [val, neg_normalization] = get_epsp_width_abs(amplitude)

val = mean(amplitude.width);

neg_normalization = false;

end
