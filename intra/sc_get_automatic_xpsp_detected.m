function sc_get_automatic_xpsp_detected(obj, v, dt, psps, response_min, response_max)

stimtimes = obj.stimtimes;
obj.automatic_xpsp_detected = false(size(stimtimes));


for i=1:length(stimtimes)
  v_sweep = sc_get_sweeps(v, 0, stimtimes(i), response_min, response_max, dt);
	
  for j=1:length(psps)
    psp = get_item(obj.parent.waveforms.cell_list, psps{j});
    if psp.spike_is_detected(v_sweep)
      obj.automatic_xpsp_detected(i) = true;
      continue
    end
  end
	
end

end