% % % clear
% % neurons = intra_get_neurons();
% % patterns = get_intra_motifs();
% % neuronIndx = 3;
% % 
% signal = hamo.intra.loadSignal(neurons(neuronIndx));
% %
% % v = signal.get_v(true, true, true, true);
% % a = .001;
% % v = filter([1-a a-1], [1 a-1], v);
% defineTemplate = hamo.gui.DefineTemplate(signal, gcf);
% % 
% dt = 1e-5;
% pretrigger = 4e-3;
% posttrigger = 18e-3;
%  
% validEpsps = arrayfun(@(x) any(strcmp(get_intra_motifs(), x.tag)), signal.amplitudes.list);
% [stimTimes, epspResponses, responseTimes, responseHeights] ...
%   = hamo.epsp.getEpspResponses(signal.amplitudes.list(validEpsps), ...
%   pretrigger, posttrigger, 2);
% epspTemplate = hamo.templates.ManualTemplate(stimTimes, 'manual');
% epspTemplate.responseTime   = responseTimes;
% epspTemplate.responseHeight = responseHeights;
% signal.addTemplate(epspTemplate)
% 


respStims = find(epspResponses);
stimIndx = respStims(1);
[sweep, time] = sc_get_sweeps(v, 0, stimTimes(stimIndx), pretrigger, ...
 posttrigger + 10e-3, dt);

defineTemplate.plotSweep(time, sweep, stimTimes(stimIndx));
axes(defineTemplate.axes12);
if epspResponses(stimIndx)
 title('Manual EPSP')
else
 title('No manual EPSP')
end


return
defineTemplate.updateTemplates(v)

stimIndx = 75
[sweep, time] = sc_get_sweeps(v, 0, stimTimes(stimIndx), pretrigger-10e-3, ...
 posttrigger + 10e-3, dt);

defineTemplate.plotSweep(time, sweep, stimTimes(stimIndx));
axes(defineTemplate.axes12);
if epspResponses(stimIndx)
title('Manual EPSP')
else
title('No manual EPSP')
end
return
templateMatch = false(length(stimTimes), length(defineTemplate.templates));
for i=1:length(defineTemplate.templates)
  template = defineTemplate.templates(i);
  for j=1:length(stimTimes)
    templateMatch(j, i) = any(hamo.filter.filtTriggerTimes(template.getTriggerTimes(dt), ...
      stimTimes(j)+pretrigger, stimTimes(j)+posttrigger));
  end
end

truePositive = false(size(templateMatch));
falsePositive = false(size(templateMatch));
falseNegative = false(size(templateMatch));

for i=1:length(defineTemplate.templates)
  truePositive(:, i) = templateMatch(:,i) & epspResponses';
  falsePositive(:, i) = templateMatch(:, i) & ~epspResponses';
  falseNegative(:, i) = ~templateMatch(:, i) & epspResponses';
end

truePos  = any(truePositive, 2);
falsePos = any(falsePositive, 2);
falseNeg = ~all(falseNegative, 2);