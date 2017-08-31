function latencies = sc_latency(triggertimes, spiketimes)

latencies = arrayfun(@(x) compute_latency(x, spiketimes), triggertimes);

end


function latency = compute_latency(triggertime, spiketimes)

spiketimes  = spiketimes(spiketimes > triggertime);
latency     = min(spiketimes) - triggertime;

if isempty(latency)
  latency = inf;
end

end

