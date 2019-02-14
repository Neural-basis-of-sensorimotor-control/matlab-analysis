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

defineTemplate = hamo.gui.DefineTemplate(signal, gcf);

% Set manual responses as trigger for defineTemplate
respStims = find(epspResponses);
defineTemplate.pretrigger = -5e-3;
defineTemplate.trigger = stimTimes(respStims);

% Update defineTemplate
defineTemplate.plotSweep

% Step through stimulation responses, identify EPSP:s

% Extract templates for each method, detect in file

% Compare results

% Evaluate, compare to manual EPSPs ?

% Make table: false positives, false negatives, true positives
%   ... identification time, computation time, (precision)