function [signal, spont_activity] = automatic_psp_detection(neuron_indx)
%Automatic PSP detection

response_min = 5e-3;
response_max = 30e-3;

response_range = response_max - response_min;

neurons = get_intra_neurons();

signal = sc_load_signal(neurons(neuron_indx));
waveforms = signal.waveforms;
amplitudes = signal.amplitudes;
patterns = get_intra_patterns();

xpsps = [];

for i=1:waveforms.n

  waveform = waveforms.get(i);

  if startswithi(waveform.tag, 'EPSP') || startswithi(waveform.tag, 'IPSP')
    xpsps = add_to_array(xpsps, waveform);
  end
end

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
  triggertimes = trigger.gettimes(0, inf);
  
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