function spont_activity = automatic_psp_detection(neuron, response_min, response_max)
%Automatic PSP detection

response_range = response_max - response_min;

ic_tmin = neuron.tmin;
ic_tmax = neuron.tmax;

signal = sc_load_signal(neuron);
xpsps_str = neuron.psp_templates;
patterns = get_intra_patterns();

xpsps = get_items(signal.waveforms.cell_list, 'tag', xpsps_str);

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