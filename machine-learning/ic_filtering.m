function ic_filtering(ic_signal, threshold_template)

% Detect EPSP with narrow thresholds
dt = 1e-5;
hist_function = @periodogram;
n = 1000;
time = (1:n)'*dt;
ic_signal = 3*randn(n, 1) + 3 + sin(dt/(2*pi*50));
epsp_indx = [1 40 700];
epsp_time_offset = [10 15 27 32];
epsp_lower_threshold = [2 4 6 2];
epsp_upper_threshold = [4 6 10 8];
threshold_template = struct('indx_offset', epsp_time_offset, 'lower_threshold', ...
    epsp_lower_threshold, 'upper_threshold', epsp_upper_threshold);

nbr_of_baseline_examples = 3;
nbr_of_epsp_examples     = 3;

% w = EPSP width
w = max(epsp_time_offset);
% for all detected EPSPs, generate power spectrum
%% epsp_indx = hamo.detection.detect_threshold_template(ic_signal, waveform);
% divide baseline in bins of width w, generate power spectrums for each bin
% 1. plot 3 randomly chosen baseline power spectrums and compare to 3
% randomly chosen EPSP power spectrums

pos = randperm(length(epsp_indx));
example_epsp_indx = epsp_indx(pos(1:nbr_of_epsp_examples));

pos = randperm(floor(length(ic_signal)/w));
example_baseline_indx = pos(1:nbr_of_baseline_examples);

clf
hold on
%f = (0:(w-1))'/(w*2*pi*dt);
for i=1:length(example_epsp_indx)
    v_epsp = ic_signal(example_epsp_indx(i) + (0:(w-1))');
    [p, F] = hist_function(v_epsp);
    f = F/(2*pi*dt);
    %hamo.plot.quickplot([f p], 'EPSP');
end
all_epsp = nan(length(f), length(epsp_indx));
for i=1:length(epsp_indx)
    all_epsp(:, i) = hist_function(ic_signal(epsp_indx(i)+(0:(w-1))'));
end
mean_epsp   = mean(all_epsp, 2);
median_epsp = median(all_epsp, 2);
std_epsp    = std(all_epsp, 0, 2);
hamo.plot.quickplot([f mean_epsp], 'mean epsp', [], 2);
hamo.plot.quickplot([f mean_epsp+std_epsp], 'mean epsp');
hamo.plot.quickplot([f mean_epsp-std_epsp], 'mean epsp');
hamo.plot.quickplot([f median_epsp], 'median epsp', [], 2);

for i=1:length(example_baseline_indx)
    p = hist_function(ic_signal(example_baseline_indx(i) + (0:(w-1))'));
    %hamo.plot.quickplot([f p], 'baseline');
end
all_baseline = nan(length(f), floor(length(ic_signal)/w));
for i=1:floor(length(ic_signal)/w)
    indx = (i-1)*w+1;
    all_baseline(:, i) = hist_function(ic_signal(indx+(0:(w-1)))');
end
mean_baseline   = mean(all_baseline, 2);
median_baseline = median(all_baseline, 2);
std_baseline    = std(all_baseline, 0, 2);
hamo.plot.quickplot([f mean_baseline], 'mean baseline', [], 2);
hamo.plot.quickplot([f mean_baseline+std_baseline], 'mean baseline');
hamo.plot.quickplot([f mean_baseline-std_baseline], 'mean baseline');
hamo.plot.quickplot([f median_baseline], 'median baseline', [], 2);

add_legend(gcf);

% 2. in the background of plot, plot median power spectrum for EPSP +/- std
% dev, and compare to median baseline power spectrum +/- std
% 4. Construct band-pass filter to highlight EPSPs
% 5. In filtered IC signal, extract manually detected / threshold-detected
% median EPSP and use cross correlation to detect EPSPs

% tuning parameters: lower and upper cutoff-frequencies for bandpass
% filters, lower and upper threshold levels for cross-correlation detection

end