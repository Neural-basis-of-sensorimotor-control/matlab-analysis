function ic_filtering(signal, threshold_template)

% Detect EPSP with narrow thresholds
signal.dt = 1e-5;
hist_function = @periodogram;

nbr_of_baseline_examples = 10;
nbr_of_epsp_examples     = 10;

% w = EPSP signal width
w = max(threshold_template.indx_offset);
% for all detected EPSPs, generate power spectrum
epsp_indx = hamo.detection.detect_threshold_template(signal.v, threshold_template);
% divide baseline in bins of wisignal.dth w, generate power spectrums for each bin
% 1. plot 3 randomly chosen baseline power spectrums and compare to 3
% randomly chosen EPSP power spectrums

pos = randperm(length(epsp_indx));
example_epsp_indx = epsp_indx(pos(1:nbr_of_epsp_examples));

pos = randperm(floor(length(signal.v)/w));
example_baseline_indx = pos(1:nbr_of_baseline_examples);

figure(1)
clf
hold on
grid on
figure(2)
clf
hold on
grid on
for i=1:length(example_epsp_indx)
    v_epsp = signal.v(example_epsp_indx(i) + (0:(w-1))');
    [p, F] = hist_function(v_epsp);
    f = F/(2*pi*signal.dt);
    figure(1)
    hamo.plot.quickplot([f p], 'EPSP');
    figure(2)
    hamo.plot.quickplot([signal.dt*(1:length(v_epsp))' v_epsp], 'EPSP');
end
if 0
    all_epsp = nan(length(f), length(epsp_indx));
    for i=1:length(epsp_indx)
        all_epsp(:, i) = hist_function(signal.v(epsp_indx(i)+(0:(w-1))'));
    end
    mean_epsp   = mean(all_epsp, 2);
    median_epsp = median(all_epsp, 2);
    std_epsp    = std(all_epsp, 0, 2);
    hamo.plot.quickplot([f mean_epsp], 'EPSP', [], 2);
    hamo.plot.quickplot([f mean_epsp+std_epsp], 'EPSP', [], 2);
    hamo.plot.quickplot([f mean_epsp-std_epsp], 'EPSP', [], 2);
end
%hamo.plot.quickplot([f median_epsp], 'median epsp', [], 2);

for i=1:length(example_baseline_indx)
    v_baseline = signal.v(example_baseline_indx(i) + (0:(w-1))');
    p = hist_function(v_baseline);
    figure(1)
    hamo.plot.quickplot([f p], 'baseline');
    figure(2)
    hamo.plot.quickplot([signal.dt*(1:length(v_baseline))' v_baseline], 'baseline');
end
if 0
    all_baseline = nan(length(f), floor(length(signal.v)/w));
    for i=1:floor(length(signal.v)/w)
        indx = (i-1)*w+1;
        all_baseline(:, i) = hist_function(signal.v(indx+(0:(w-1)))');
    end
    mean_baseline   = mean(all_baseline, 2);
    median_baseline = median(all_baseline, 2);
    std_baseline    = std(all_baseline, 0, 2);
    hamo.plot.quickplot([f mean_baseline], 'baseline', [], 2);
    hamo.plot.quickplot([f mean_baseline+std_baseline], 'baseline', [], 2);
    hamo.plot.quickplot([f mean_baseline-std_baseline], 'baseline', [], 2);
end
%hamo.plot.quickplot([f median_baseline], 'median baseline', [], 2);
add_legend([figure(1) figure(2)]);


for i=1:10
    indx_min = epsp_indx(i)-10000;
    indx_max = indx_min+1e5;
    
    %v_filtered = highpass(signal.v(indx_min:indx_max), 15, 1/signal.dt);
    v_filtered = bandpass(signal.v(indx_min:indx_max), [15 200], 1/signal.dt);
    
    figure(i+10)
    clf
    hold on
    grid on
    time = (1:(indx_max-indx_min+1))'*signal.dt;
    plot(time, signal.v(indx_min:indx_max), 'Tag', 'unfiltered')
    plot(time, v_filtered, 'Tag', 'filtered')
    
    epsp_detected = epsp_indx(epsp_indx>indx_min & epsp_indx<indx_max);
    
    for j=1:length(epsp_detected)
        vOffset = signal.v(epsp_detected(j));
        plot((epsp_detected(j)-indx_min+threshold_template.indx_offset)*signal.dt, ...
            vOffset+threshold_template.lower_threshold, '+');
        plot((epsp_detected(j)-indx_min+threshold_template.indx_offset)*signal.dt, ...
            vOffset+threshold_template.upper_threshold, '+');
    end
    plot((epsp_detected-indx_min)*signal.dt, zeros(size(epsp_detected)), 's');
    plot((epsp_detected-indx_min+w)*signal.dt, zeros(size(epsp_detected)), 's');
    add_legend(gcf)

end
% 2. in the background of plot, plot median power spectrum for EPSP +/- std
% dev, and compare to median baseline power spectrum +/- std
% 4. Construct band-pass filter to highlight EPSPs
% 5. In filtered IC signal, extract manually detected / threshold-detected
% median EPSP and use cross correlation to detect EPSPs

% tuning parameters: lower and upper cutoff-frequencies for bandpass
% filters, lower and upper threshold levels for cross-correlation detection

end