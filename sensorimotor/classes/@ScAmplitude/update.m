function update(obj, v, response_min, response_max, remove_fraction)

obj.is_updated = false;

dim = size(obj.stimtimes);
obj.rise = nan(dim);
obj.start = nan(dim);
obj.stop = nan(dim);
obj.is_pseudo = nan(dim);

obj.start = sc_get_amplitude_pseudo_start(obj);
obj.stop = sc_get_amplitude_pseudo_stop(obj, v);
obj.is_pseudo = ~obj.valid_data;
obj.rise = sc_get_amplitude_pseudo_rise(obj.start, obj.stop, ...
	obj.is_pseudo, obj, v);
sc_get_automatic_xpsp_detected(obj, ...
	response_min, response_max);
obj.is_median_and_automatic = sc_get_is_median_and_automatic(obj, remove_fraction);
obj.rise = get_normalized_rise(obj, obj.rise);

obj.is_updated = true;

end