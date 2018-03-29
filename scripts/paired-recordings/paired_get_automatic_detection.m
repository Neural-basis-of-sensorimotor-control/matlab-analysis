function [indx, lowpass_freq, lowpass_t, highpass_freq, highpass_t] = ...
  paired_get_automatic_detection(t1, t2)

pretrigger  = -2;%-1;
posttrigger = 2;%1;
kernelwidth = 1e-3;
binwidth    = 1e-3;

[lowpass_freq, lowpass_t] = sc_kernelhist(true, t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
[highpass_freq, highpass_t] = sc_kernelhist(true, t1, t2, pretrigger, posttrigger, kernelwidth, binwidth);

avg_freq = mean(lowpass_freq((lowpass_t>pretrigger+.2 & lowpass_t < -.5) | (lowpass_t>.5 & lowpass_t < posttrigger-.2)));

indx = nan(7, 1);

indx(3) = find(lowpass_freq < avg_freq & lowpass_t < 0, 1, 'last');
indx(1) = find(lowpass_freq > avg_freq & lowpass_t < lowpass_t(indx(3)), 1, 'last');
[~, indx(2)] = min(lowpass_freq(indx(1):indx(3)));
indx(2) = indx(2) + indx(1) - 1;

indx(5) = find(lowpass_freq < avg_freq & lowpass_t > 0, 1, 'first');
[~, indx(4)] = max(highpass_freq(indx(3):indx(5)));
indx(4) = indx(4) + indx(3) - 1;

indx(7) = find(lowpass_freq > avg_freq & lowpass_t > lowpass_t(indx(5)), 1, 'first');
[~, indx(6)] = min(lowpass_freq(indx(5):indx(7)));
indx(6) = indx(6) + indx(5) - 1;

end