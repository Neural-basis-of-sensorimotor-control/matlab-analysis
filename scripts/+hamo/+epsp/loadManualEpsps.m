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
% [stimStimes, indx] = sort(stimTimes);
% epspResponses = epspResponses(indx);
% 
% v = signal.get_v(true, true, true, true);
% a = .001;
% v = filter([1-a a-1], [1 a-1], v);
