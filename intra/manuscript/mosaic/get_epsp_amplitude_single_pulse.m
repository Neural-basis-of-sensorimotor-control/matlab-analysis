function [val, neg_normalization] = get_epsp_amplitude_single_pulse(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));
norm_constant = amplitude.parent.userdata.single_pulse_height(ind);

val = mean(amplitude.height) / ...
  abs(norm_constant);

neg_normalization = norm_constant < 0;

end

