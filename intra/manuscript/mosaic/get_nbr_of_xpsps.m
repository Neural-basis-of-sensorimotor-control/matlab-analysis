function [val, neg_normalization] = get_nbr_of_xpsps(amplitude)

val = numel(amplitude.height);

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

neg_normalization = amplitude.parent.userdata.single_pulse_height(ind) <= 0;

end