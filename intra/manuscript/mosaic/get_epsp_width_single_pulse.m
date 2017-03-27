
function [val, neg_normalization] = get_epsp_width_single_pulse(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

val = mean(amplitude.width) / ...
  amplitude.parent.userdata.single_pulse_width(ind);

neg_normalization = false;

end
