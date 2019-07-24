
if 1
    % Constants
    dt = 1e-5;
    pretrigger = 4e-3;
    posttrigger = 18e-3;
    minEpspAmplitude = 5;
    
    % Params
    neuronIndx = 5;
    
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
    stimTimesEvokedResponses = stimTimes(epspResponses);
    
    
    tmin = stimTimesEvokedResponses(5);
    
    [v, t] = sc_get_sweeps(signal.get_v(false, true, false, false), 0, tmin, 0, 10, dt);
end

vFiltered = bandpass(v, [15 1e4], 1/dt);
%vFiltered = highpass(v, 15, 1/dt);

figure
hold on
grid on
plot(t, v, 'Tag', 'raw')
plot(t, vFiltered, 'Tag', 'filtered', 'LineWidth', 1);
xlim([0 1])
add_legend(gcf)