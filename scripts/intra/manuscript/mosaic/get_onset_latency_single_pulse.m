function [val, neg_normalization] = get_onset_latency_single_pulse...
  (amplitude, selection)

if nargin<2
  selection = 'all';
end

str = strsplit(amplitude.tag, '#');
str = str{2};
ind = str2num(str(2));

latencies = amplitude.latency;
heights = amplitude.height;

switch selection
  case 'all'
    mean_latency = mean(latencies);
  case 'positive'
    mean_latency = mean(latencies(heights>=0));
  case 'negative'
    mean_latency = mean(latencies(heights<0));
  otherwise
    error('Illegal option: %s', selection);
end

if isempty(mean_latency)
  val = 0;
else
  val = mean_latency / amplitude.parent.userdata.single_pulse_latency(ind);
end

neg_normalization = false;

end
