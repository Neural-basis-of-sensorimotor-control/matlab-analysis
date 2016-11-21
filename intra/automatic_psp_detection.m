function spont_activity = automatic_psp_detection(signal, ...
  ic_tmin, ic_tmax, xpsps_str, response_min, response_max)
%Automatic PSP detection

response_range = response_max - response_min;

ic_tmin = neuron.tmin;
ic_tmax = neuron.tmax;

signal = sc_load_signal(neuron);
waveforms = neuron.

amplitudes = signal.amplitudes;
patterns = get_intra_patterns();

xpsps = get_items(signal.waveforms.cell_list, 'tag', xpsps_str);

for i=1:amplitudes.n
  
  amplitude = amplitudes.get(i);
  stimtimes = amplitude.stimtimes;
  
  for j=1:length(stimtimes)
    
    tmin = stimtimes(j) + response_min;
    tmax = stimtimes(j) + response_max;
        
    amplitude.automatic_xpsp_detected(j) = xpsp_detected(xpsps, tmin, tmax);
    
  end
end

nbr_of_stims = 0;
nbr_of_responses = 0;

for i=1:length(patterns)
  
  pattern = patterns{i};
  
  trigger = signal.parent.gettriggers(0, inf).get('tag', pattern);
  triggertimes = trigger.gettimes(ic_tmin, ic_tmax);
  
  for j=2:length(triggertimes)
		
    for tstop=triggertimes(j):-response_range:(triggertimes(j)-.5)
			tstart = tstop - response_range;
			
			nbr_of_stims = nbr_of_stims + 1;
			if xpsp_detected(xpsps, tstart, tstop)
				nbr_of_responses = nbr_of_responses + 1;
			end
    end
  end
end

spont_activity = nbr_of_responses / nbr_of_stims;

end