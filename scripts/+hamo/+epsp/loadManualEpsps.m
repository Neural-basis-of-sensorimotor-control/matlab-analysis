% clear
% neurons = intra_get_neurons();
% patterns = get_intra_motifs();
% neuronIndx = 2;
% signal = sc_load_signal(neurons(neuronIndx));
% dt = 1e-5;
% pretrigger = 4e-3;
% posttrigger = 18e-3;
% 
% validEpsps = arrayfun(@(x) any(strcmp(get_intra_motifs(), x.tag)), signal.amplitudes.list);
% [stimTimes, epspResponses] = hamo.epsp.getEpspResponses(signal.amplitudes.list(validEpsps), ...
%   pretrigger, posttrigger, 0);
% [stimTimes, indx] = sort(stimTimes);
% epspResponses = epspResponses(indx);
% 
% v = signal.get_v(true, true, true, true);
% a = .001;
% v = filter([1-a a-1], [1 a-1], v);
%defineTemplate = hamo.epsp.DefineTemplate(gcf);

stimIndx = 37;
stimIndx = 52
[sweep, time] = sc_get_sweeps(v, 0, stimTimes(stimIndx), pretrigger, ...
  posttrigger + 10e-3, dt);

defineTemplate.plotSweep(time, sweep);
axes(defineTemplate.axes0);
if epspResponses(stimIndx)
  title('Manual EPSP')
else
  title('No manual EPSP')
end