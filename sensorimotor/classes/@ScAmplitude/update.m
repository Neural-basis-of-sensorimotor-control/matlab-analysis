function update(obj, v, dt, psp_templates, response_min, response_max)

obj.is_updated = false;

is_detected = sc_get_automatic_xpsp_detected(obj, psp_templates, response_min, response_max);
obj.userdata.fraction_detected = nnz(is_detected) / length(obj.stimtimes);

obj.is_updated = true;

end