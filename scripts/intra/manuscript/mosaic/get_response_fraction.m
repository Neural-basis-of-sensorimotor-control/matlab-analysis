function [val, under_threshold] = get_response_fraction(amplitude, ...
  height_limit, min_epsp_nbr)

[responses, all_heights] = amplitude.get_amplitude_height(0);

val = length(responses)/length(all_heights);

under_threshold = ~amplitude.intra_is_significant_response(height_limit, ...
  min_epsp_nbr);

end
