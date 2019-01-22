clc
clear
% Constants
dt = 1e-5;
pretrigger = 4e-3;
posttrigger = 18e-3;
minEpspAmplitude = 5;

% Params
neuronIndx = 11;

% Load neurons
neurons = intra_get_neurons();
patterns = get_intra_motifs();

% Load signal
signal = hamo.intra.loadSignal(neurons(neuronIndx));

% Extract manually detected EPSPs
validEpsps = arrayfun(@(x) any(strcmp(get_intra_motifs(), x.tag)), signal.amplitudes.list);

[stimTimes, epspResponses, responseTimes, responseHeights] ...
  = hamo.epsp.getEpspResponses(signal.amplitudes.list(validEpsps), ...
  pretrigger, posttrigger, minEpspAmplitude, inf);
epspTemplate = hamo.templates.ManualTemplate(stimTimes, 'manual');
epspTemplate.responseTime   = responseTimes;
epspTemplate.responseHeight = responseHeights;

% Remove previously created templates
for i=1:length(signal.templates)
  signal.rmTemplate(signal.templates{i});
end
signal.addTemplate(epspTemplate)

% Create define template
defineTemplate = hamo.gui.DefineTemplate(signal, gcf);

% Set manual responses as trigger for defineTemplate
respStims = find(epspResponses);
defineTemplate.pretrigger = -5e-3;
defineTemplate.trigger = stimTimes(respStims);

% Update defineTemplate
defineTemplate.plotSweep




return
n = 202;
defineTemplate.triggerIndx=respStims();%n:n+10);
defineTemplate.plotSweep();
for i=1:10
  pause(.05)
  beep
end
return
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