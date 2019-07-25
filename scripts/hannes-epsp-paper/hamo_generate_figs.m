% clc
% close all
% clear
% 
% % Constants
% pretrigger = 4e-3;
% posttrigger = 18e-3;
% minEpspAmplitude = 5;
% 
% % Load neurons
% neurons = intra_get_neurons();
% patterns = get_intra_motifs();
% % % 
% % signalList = ScList();
% % 
% % for i=1:length(neurons)
% %   fprintf('%d out of %d\n', i, length(neurons));
% %   % Load signal
% %   signal = hamo.signals.PreFilteredSignal.loadFromScNeuron(neurons(i));
% %   signal.isUpdated = true;
% %   signalList.add(signal);
% % end
% % 
% % obj = signalList.list;
% 
% d = load([sc_settings.get_default_experiment_dir() 'EPSP_detection_sc.mat']);
% signals = d.obj;
% clear d;

%% Params
neuronIndx = 1;
%% Load signal
signal = signals(neuronIndx);

% Extract manually detected EPSPs
validEpsps = arrayfun(@(x) any(strcmp(get_intra_motifs(), x.tag)), signal.amplitudes.list);

[stimTimes, epspResponses, responseTimes, responseHeights] ...
  = hamo.epsp.getEpspResponses(signal.amplitudes.list(validEpsps), ...
  pretrigger, posttrigger, minEpspAmplitude, inf);
epspTemplate = hamo.templates.ManualTemplate(stimTimes, 'manual');
epspTemplate.responseTime   = responseTimes;
epspTemplate.responseHeight = responseHeights;

h = hamo.gui.DefineTemplate(signal, gcf);

% Set manual responses as trigger for defineTemplate
respStims = find(epspResponses);
h.pretrigger = -5e-3;
h.trigger = stimTimes(respStims);
% Update defineTemplate
h.updatePlots




