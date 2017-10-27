function [is_significant, nbr_of_manual_detections] = intra_is_significant_response(obj, height_limit, ...
  min_epsp_nbr)

val                      = obj.userdata.fraction_detected;
nbr_of_manual_detections = length(obj.get_amplitude_height(height_limit));

is_significant = val >= intra_get_activity_threshold(obj.parent) && ...
  nbr_of_manual_detections >= min_epsp_nbr;

end