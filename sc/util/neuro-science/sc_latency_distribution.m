function [latency_distribution, bintimes, n] = ...
  sc_latency_distribution(triggertimes, spiketimes, binwidth, tmax)

latency = sc_latency(triggertimes, spiketimes);

if nargin < 4
  tmax = max(latency(latency<inf));
end

edges                 = (0:binwidth:tmax);
bintimes              = edges(1:end-1) + binwidth/2;

latency               = latency(latency <= tmax);
latency_distribution  = histcounts(latency, edges); 
n                     = sum(latency_distribution);
latency_distribution  = latency_distribution / n;
