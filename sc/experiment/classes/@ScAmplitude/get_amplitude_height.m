function [heights, all_heights] = get_amplitude_height(obj, threshold, indx)

all_heights = obj.data(:, 4) - obj.data(:, 2);
all_heights(~isfinite(all_heights) | all_heights < threshold) = nan;

heights = all_heights(isfinite(all_heights));

if nargin >= 3
  heights = heights(indx);
end

end
