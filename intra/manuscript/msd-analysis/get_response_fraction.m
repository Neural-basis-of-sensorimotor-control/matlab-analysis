

function [val, under_threshold] = get_response_fraction(amplitude)

val = amplitude.userdata.fraction_detected;

under_threshold = val < get_activity_threshold(amplitude.parent);

end
