

function [val, neg_normalization] = get_onset_latency_single_pulse(amplitude)

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

val = mean(amplitude.latency) / ...
  amplitude.parent.userdata.single_pulse_latency(ind);

neg_normalization = false;

end
