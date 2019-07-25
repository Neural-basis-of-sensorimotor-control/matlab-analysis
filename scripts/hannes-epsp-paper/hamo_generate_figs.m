clc
close all
clear all

% Constants
pretrigger = 4e-3;
posttrigger = 18e-3;
minEpspAmplitude = 5;

% Load neurons
neurons = intra_get_neurons();
patterns = get_intra_motifs();

lower_cutoff = 15;
upper_cutoff = 1e4;

for i=1:length(neurons)
  fprintf('%d out of %d\n', i, length(neurons));
  % Load signal
  signal = hamo.intra.loadSignal(neurons(i));
  % Save with filtered channel
  signal = hamo.signals.PreFilteredSignal.clone(signal);
  signal.filterData(lower_cutoff, upper_cutoff);
end
return

% Params
neuronIndx = 1;
% Load signal
signal = hamo.signals.PreFilteredSignal.loadFromScNeuron(neurons(neuronIndx));

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
defineTemplate.updatePlots




