function [val, under_threshold] = intra_get_nbr_of_manual_amplitudes(amplitude, ...
  height_limit, min_epsp_nbr)

val = length(amplitude.get_amplitude_height(height_limit));

under_threshold = ~amplitude.intra_is_significant_response(height_limit, ...
  min_epsp_nbr);

end