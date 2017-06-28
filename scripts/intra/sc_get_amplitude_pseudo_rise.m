function rise = sc_get_amplitude_pseudo_rise(start, stop, is_pseudo, ...
	amplitude, v_full)

signal = amplitude.parent_signal;
dt = signal.dt;
rise = amplitude.data(:,4) - amplitude.data(:,2);

if all(~isfinite(rise))
	return
end

if islogical(is_pseudo)
  indx = find(is_pseudo);
end

for i=1:length(indx)
  ind = indx(i);
  v = sc_get_sweeps(v_full, 0, amplitude.stimtimes(ind), ...
    start, stop, dt);
	
  rise(ind) = v(end) - v(1);
end

end
