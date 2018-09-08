function [indx, lowpass_freq, lowpass_t, highpass_freq, highpass_t, avg_freq, mean_data] = ...
  paired_get_automatic_detection(t1, t2, take_sub_samples, rectify_order)

if nargin<3
  take_sub_samples = true;
end

if nargin<4
  rectify_order = false;
end

window_width = 4;
pretrigger  = -window_width/2;
posttrigger = window_width/2;
kernelwidth = 1e-3;
binwidth    = 1e-3;

[lowpass_freq, lowpass_t] = sc_kernelhist(true, t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
if rectify_order && sum(lowpass_freq(lowpass_t<0))>sum(lowpass_freq(lowpass_t>0))
  tmp = t2;
  t2 = t1;
  t1 = tmp;
  [lowpass_freq, lowpass_t] = sc_kernelhist(true, t1, t2, pretrigger, posttrigger, 10*kernelwidth, binwidth);
end

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

if ~take_sub_samples
  return
end

subsample_size = 100;
nbr_of_subsamples = floor(length(t1)/subsample_size);
sub_indx = randperm(nbr_of_subsamples*subsample_size);
dim2 = [nbr_of_subsamples, 1];

pretrigger_peak_t   = nan(dim2);
peritrigger_peak_t  = nan(dim2);
posttrigger_peak_t  = nan(dim2);
pretrigger_peak_value  = nan(dim2);
peritrigger_peak_value = nan(dim2);
posttrigger_peak_value = nan(dim2);

for j=1:nbr_of_subsamples
  [indx, lowpass_freq, lowpass_t, highpass_freq, ~, avg_freq] = ...
    paired_get_automatic_detection(t1( sub_indx( (1:subsample_size) + (j-1)*subsample_size)), t2, false, false);
  pretrigger_peak_t(j) = lowpass_t(indx(2));
  peritrigger_peak_t(j) = lowpass_t(indx(4));
  posttrigger_peak_t(j) = lowpass_t(indx(6));
  pretrigger_peak_value(j) = .5*(2*lowpass_freq(indx(2)) - lowpass_freq(indx(1)) - lowpass_freq(indx(3)))/avg_freq;
  peritrigger_peak_value(j) = .5*(2*highpass_freq(indx(4)) - lowpass_freq(indx(3)) - lowpass_freq(indx(5)))/avg_freq;
  posttrigger_peak_value(j) = .5*(2*lowpass_freq(indx(6)) - lowpass_freq(indx(5)) - lowpass_freq(indx(7)))/avg_freq;
end

ts = tinv([0.025  0.975], nbr_of_subsamples-1);
mean_data.pre.peak_time = mean(pretrigger_peak_t) + std(pretrigger_peak_t)/nbr_of_subsamples * ts;
mean_data.peri.peak_time = mean(peritrigger_peak_t) + std(peritrigger_peak_t)/nbr_of_subsamples * ts;
mean_data.post.peak_time = mean(posttrigger_peak_t) + std(posttrigger_peak_t)/nbr_of_subsamples * ts;
mean_data.pre.peak_value = mean(pretrigger_peak_value) + std(pretrigger_peak_value)/nbr_of_subsamples * ts;
mean_data.peri.peak_value = mean(peritrigger_peak_value) + std(peritrigger_peak_value)/nbr_of_subsamples * ts;
mean_data.post.peak_value = mean(posttrigger_peak_value) + std(posttrigger_peak_value)/nbr_of_subsamples * ts;

end