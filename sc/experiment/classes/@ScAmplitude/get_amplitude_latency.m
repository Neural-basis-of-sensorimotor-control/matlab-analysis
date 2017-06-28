function [latencies, all_latencies] = get_amplitude_latency(obj, height_threshold, indx)

all_heights = obj.data(:, 4) - obj.data(:, 2);
all_latencies = obj.data(:, 3) - obj.data(:, 1);
all_latencies(~isfinite(all_heights) & all_heights < height_threshold) = nan;
latencies = all_latencies(isfinite(all_latencies));

if nargin >= 3
  latencies = latencies(indx);
end

end
