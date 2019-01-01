function [stimTimes, epspResponses, responseTimes, responseHeights] = ...
  getEpspResponses(amplitudes, minResponseTime, maxResponseTime, minEpspAmplitude)

stimTimes       = [];
epspResponses   = [];
responseTimes   = nan(2, 5200);
responseHeights = nan(2, 5200);
columnCount = 0;
for i=1:length(amplitudes)
  stimTimes = concat_list(stimTimes, amplitudes(i).stimtimes);
  latency = amplitudes(i).data(:, 1);
  height  = amplitudes(i).data(:, 4) - amplitudes(i).data(:, 2);
  isResponse = isfinite(latency) & ...
    latency >= minResponseTime   & ...
    latency <= maxResponseTime   & ...
    height >= minEpspAmplitude;
  epspResponses = concat_list(epspResponses, isResponse);

  indx  = columnCount + find(isResponse);%1:length(amplitudes(i).stimtimes);
  responseHeights(:, indx) = amplitudes(i).data(isResponse, [2 4])';
  responseTimes(:, indx)   = amplitudes(i).data(isResponse, [1 3])';
  
  columnCount = columnCount + length(amplitudes(i).stimtimes);
end
responseHeights = responseHeights(:, 1:columnCount);
responseTimes   = responseTimes(:,1:columnCount);

end

