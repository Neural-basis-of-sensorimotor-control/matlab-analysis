function [val, under_threshold] = get_normalized_response_fraction(amplitude)


val = amplitude.userdata.fraction_detected/parent.userdata.avg_spont_activity;

under_threshold = amplitude.userdata.fraction_detected < get_activity_threshold(amplitude.parent);

end