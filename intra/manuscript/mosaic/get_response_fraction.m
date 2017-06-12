function [val, under_threshold] = get_response_fraction(amplitude, ...
  height_limit, min_epsp_nbr)

val = amplitude.userdata.fraction_detected;

under_threshold = ~amplitude.intra_is_significant_response(height_limit, ...
  min_epsp_nbr);

end
