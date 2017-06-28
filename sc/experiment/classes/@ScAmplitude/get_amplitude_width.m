function [widths, all_widths] = get_amplitude_width(obj, height_threshold, indx)

all_heights = obj.data(:, 4) - obj.data(:, 2);
all_widths = obj.data(:, 3) - obj.data(:, 1);
all_widths(~isfinite(all_heights) & all_heights < height_threshold) = nan;
widths = all_widths(isfinite(all_widths));

if nargin >= 3
  widths = widths(indx);
end

end
