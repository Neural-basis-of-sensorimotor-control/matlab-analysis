function is_significant = intra_is_significant_response(obj, height_limit, ...
  min_epsp_nbr)

val = obj.userdata.fraction_detected;

is_significant = val >= intra_get_activity_threshold(obj.parent) && ...
  (length(obj.get_amplitude_height(height_limit)) >= min_epsp_nbr);

end