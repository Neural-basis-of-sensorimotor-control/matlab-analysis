function val = sc_get_automatic_xpsp_detected(amplitude, v, dt, psps, response_min, response_max)

stimtimes = amplitude.stimtimes;
val = false(size(stimtimes));


for i=1:length(stimtimes)
  v_sweep = sc_get_sweeps(v, 0, stimtimes(i), response_min, response_max, dt);
	
  for j=1:length(psps)
    psp = get_item(amplitude.parent.waveforms.cell_list, psps{j});
    
    if ~isempty(psp) && psp.spike_is_detected(v_sweep)
      val(i) = true;
      continue
    end
  end
	
end

end