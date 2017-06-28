function [response, spont] = plot_conditional_pattern_response(trigger_time, presynaptic_spiketime, ...
  postsynaptic_spiketime, trigger_lbl, cell1_lbl, cell2_lbl, varargin)

peakwidth_s = 1e-2;
threshold_hz = 15;


s.pretrigger = -1;
s.posttrigger = 2;
s.kernelwidth = .001;
s.binwidth = .0001;

s.pretrigger2 = -1;
s.posttrigger2 = 2;
s.kernelwidth2 = .02;
s.binwidth2 = .0001;
s.max_roi = .1;
s.min_latency = .0005;
s.max_latency = .4;

s = parse_inputs(s, varargin{:});

[pretrigger, posttrigger, kernelwidth, binwidth, ...
  pretrigger2, posttrigger2, kernelwidth2, binwidth2, ...
  max_roi, min_latency, max_latency] = ...
  expand_inputs(s, 'pretrigger', 'posttrigger', 'kernelwidth', 'binwidth', ...
  'pretrigger2', 'posttrigger2', 'kernelwidth2', 'binwidth2', ...
  'max_roi', 'min_latency', 'max_latency');

connected = [];
unconnected = [];

for i=1:length(postsynaptic_spiketime)
  if any( (postsynaptic_spiketime(i) - presynaptic_spiketime) >= min_latency & ...
      (postsynaptic_spiketime(i) - presynaptic_spiketime) <= max_latency)
    connected = [connected; postsynaptic_spiketime(i)];
  else
    unconnected = [unconnected; postsynaptic_spiketime(i)];
  end
end

n = min(length(connected), length(unconnected));

connected = connected(1:n);
unconnected = unconnected(1:n);

incr_fig_indx();

%subplot(121)
clf
hold on
[f_c, t] = sc_kernelhist(trigger_time, connected, pretrigger2, posttrigger2, kernelwidth2, binwidth2);
title(sprintf('%d', length(connected)))

%subplot(122)
f_uc = sc_kernelhist(trigger_time, unconnected, pretrigger2, posttrigger2, kernelwidth2, binwidth2);
title(sprintf('%d', length(unconnected)))

legend('connected', 'unconnected')


response = log(sum(f_c(t>0))/sum(f_uc(t>0)));
spont = log(sum(f_c(t<0))/sum(f_uc(t<0)));
fprintf('%g %g %g\n', sum(f_c(t<0)), sum(f_uc(t<0)), sum(f_c(t<0))/(sum(f_c(t<0)) + sum(f_uc(t<0))));
%linkaxes(get_axes(gcf));















% %
% % [f, t] = sc_kernelfreq(trigger_time, presynaptic_spiketime, pretrigger, ...
% %   posttrigger, kernelwidth, binwidth);
%
% % t_peaks = t(t > 0 & f > threshold_hz & t < max_roi);
% % t_roi = bsxfun(@plus, t_peaks', [-peakwidth_s peakwidth_s]/2);
%
% presynaptic_has_fired = false(size(trigger_time));
%
% for i=1:length(presynaptic_has_fired)
%   presynaptic_has_fired(i) = any(presynaptic_spiketime >= trigger_time(i) & ...
%     presynaptic_spiketime <= (trigger_time(i)+s.max_roi));
% end
%
%
%
%
% % for i=1:size(t_roi,1)
% %
% %   for j=1:length(trigger_time)
% %
% %     tmp_time = presynaptic_spiketime - trigger_time(j);
% %
% %     presynaptic_has_fired(j) = presynaptic_has_fired(j) || ...
% %       any(tmp_time >= t_roi(i,1) & tmp_time <= t_roi(i,2));
% %   end
% %
% %   nnz(presynaptic_has_fired)
% %
% % end
%
% incr_fig_indx()
%
% subplot(121)
% cla
% [f_fired, tt] = sc_kernelhist(trigger_time(presynaptic_has_fired), postsynaptic_spiketime, ...
%   pretrigger2, posttrigger2, kernelwidth2, binwidth2);
% title([trigger_lbl ': ' cell1_lbl ' has fired (n = ' num2str(nnz(presynaptic_has_fired)) ')']);
% ylabel([cell2_lbl ' [Hz]']);
% grid on
%
% % hold on
% % for i=1:size(t_roi,1)
% %   plot([t_roi(i,1) t_roi(i,2)], [0 0], '*')
% % end
% % hold off
%
% subplot(122)
% cla
% f_not_fired = sc_kernelhist(trigger_time(~presynaptic_has_fired), postsynaptic_spiketime, ...
%   pretrigger2, posttrigger2, kernelwidth2, binwidth2);
% title([trigger_lbl ': ' cell1_lbl ' has not fired (n = ' num2str(nnz(~presynaptic_has_fired)) ')']);
% ylabel([cell2_lbl ' [Hz]']);
% grid on
%
%
% indx = tt > max_roi & tt < .3;
%
% avg_fired = sum(f_fired(indx));
% avg_not_fired = sum(f_not_fired(indx));
%
% fprintf('%f\t%f\t%f\n', avg_fired, avg_not_fired, avg_fired / (avg_fired + avg_not_fired));
%
%
% % hold on
% % % for i=1:size(t_roi,1)
% % %   plot([t_roi(i,1) t_roi(i,2)], [0 0], '*')
% % % end
% % % hold off
%
% linkaxes(get_axes(gcf));
% %indx_roi = bsxfun(@plus, indx_peaks, round(-(peakwidth:peakwidth)/(2*dt)));




