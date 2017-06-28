function [val, under_threshold] = get_normalized_response_fraction(amplitude, ...
  height_limit, min_epsp_nbr)

val = amplitude.userdata.fraction_detected/amplitude.parent.userdata.avg_spont_activity;

under_threshold = ~amplitude.intra_is_significant_response(height_limit, ...
  min_epsp_nbr);

end