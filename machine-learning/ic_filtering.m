function ic_filtering(v, waveform)

% Detect EPSP with narrow thresholds
dt = 1e-5;
%n = 1000;
%time = (1:n)'*dt;
%ic_signal = 3*randn(n, 1) + 3 + sin(dt/(2*pi*50));
%epsp_indx = [1 40 700];
%epsp_time_indx = [10 15 27 32];
%epsp_lower_threshold = [2 4 6 2];
%epsp_upper_threshold = [4 6 10 8];
%waveform = struct('time_indx', epsp_time_indx, 'lower_threshold', ...
%    epsp_lower_threshold, 'upper_threshold', epsp_upper_threshold);

nbr_of_baseline_examples = 3;
nbr_of_epsp_examples     = 3;

% w = EPSP width
w = max(epsp_time_indx);
% for all detected EPSPs, generate power spectrum
epsp_indx = hamo.detection.detect_threshold_template(ic_signal, waveform);
% divide baseline in bins of width w, generate power spectrums for each bin
% 1. plot 3 randomly chosen baseline power spectrums and compare to 3
% randomly chosen EPSP power spectrums

pos = randperm(length(epsp_indx));
example_epsp_indx = epsp_indx(pos(1:nbr_of_epsp_examples));

pos = randperm(floor(length(v)/w));
example_baseline_indx = pos(1:nbr_of_baseline_examples);

clf
hold on
f = (0:(w-1))'/(w*2*pi*dt);
for i=1:length(example_epsp_indx)
    v_epsp = v(example_epsp_indx(i) + (0:(w-1))');
    p = periodogram(v_epsp);
    hamo.plot.quickplot(f, p, 'EPSP');
end
for i=1:length(example_baseline_indx)
    p = v(example_baseline_indx(i) + (0:(w-1))');
    hamo.plot.quickplot(f, p, 'baseline');
end
add_legend(gcf);

% 2. in the background of plot, plot median power spectrum for EPSP +/- std
% dev, and compare to median baseline power spectrum +/- std
% 4. Construct band-pass filter to highlight EPSPs
% 5. In filtered IC signal, extract manually detected / threshold-detected
% median EPSP and use cross correlation to detect EPSPs

% tuning parameters: lower and upper cutoff-frequencies for bandpass
% filters, lower and upper threshold levels for cross-correlation detection

end