function [stimTimes, epspResponses] = getEpspResponses(amplitudes, minResponseTime, ...
  maxResponseTime, minEpspAmplitude)

stimTimes = [];
epspResponses = [];

for i=1:length(amplitudes)
  stimTimes = concat_list(stimTimes, amplitudes(i).stimtimes);
  latency = amplitudes(i).data(:, 1);
  height  = amplitudes(i).data(:, 4) - amplitudes(i).data(:, 2);
  isResponse = isfinite(latency) & ...
    latency >= minResponseTime   & ...
    latency <= maxResponseTime   & ...
    height >= minEpspAmplitude;
  epspResponses = concat_list(epspResponses, isResponse);
end

end

