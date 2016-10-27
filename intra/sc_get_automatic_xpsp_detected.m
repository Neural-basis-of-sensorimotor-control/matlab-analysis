function sc_get_automatic_xpsp_detected(obj, response_min, response_max)

signal = obj.parent_signal;
waveforms = signal.waveforms;

xpsps = [];

for i=1:waveforms.n

  waveform = waveforms.get(i);

  if startswithi(waveform.tag, 'EPSP') || startswithi(waveform.tag, 'IPSP')
    xpsps = add_to_array(xpsps, waveform);
  end
end

stimtimes = obj.stimtimes;

for j=1:length(stimtimes)
	
	tmin = stimtimes(j) + response_min;
	tmax = stimtimes(j) + response_max;
	
	obj.automatic_xpsp_detected(j) = xpsp_detected(xpsps, tmin, tmax);
	
end

end