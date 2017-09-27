function val = intra_get_automatic_xpsp_detected(amplitude, psps, response_min, response_max)

stimtimes = amplitude.stimtimes;
val = false(size(stimtimes));

for i=1:length(stimtimes)
  
  for j=1:length(psps)
  
    psp = get_item(amplitude.parent.waveforms.cell_list, psps{j});
    
    if ~isempty(psp) && psp.spike_is_detected(stimtimes(i) + response_min, ...
        stimtimes(i) + response_max)
      
      val(i) = true;
      continue
  
    end
    
  end
  
end
