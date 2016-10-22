%Automatic PSP detection
clc

clear

neuron_indx = 1
load_gui_mgr

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

% for i=1:amplitudes.n
%   
%   amplitude = amplitudes.get(i);
%   stimtimes = amplitude.stimtimes;
%   
%   for j=1:length(stimtimes)
%     
%     tmin = stimtimes(j) + 8e-3;
%     tmax = stimtimes(j) + 3e-2;
%         
%     amplitude.automatic_xpsp_detected(j) = xpsp_detected(xpsps, tmin, tmax);
%     
%   end
% end

for i=1:length(patterns)
  
  pattern = patterns{i};
  
  trigger = h.viewer.file.gettriggers(0, inf).get('tag', pattern);
  triggertimes = trigger.gettimes(0, inf);
  
  for j=2:length(triggertimes)
    for tstop=triggertimes(j):-trange:(triggertimes(j)-.5)
      
    end
  end
end