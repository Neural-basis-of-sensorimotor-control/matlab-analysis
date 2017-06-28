function [frequency, bintimes] = sc_kernelfreq(stimtimes, spiketimes, pretrigger,...
  posttrigger, kernelwidth, binwidth, varargin)
%frequency, bintimes] = sc_kernelfreq(stimtimes, spiketimes, pretrigger,...
%  posttrigger, kernelwidth, binwidth, varargin)

if nargin<6
  binwidth = kernelwidth; 
end

times = sc_perieventtimes(stimtimes,spiketimes,pretrigger,posttrigger);
bintimes = pretrigger:binwidth:posttrigger;

if ~isempty(times)
  [frequency, bintimes] = ksdensity(times, bintimes, 'bandwidth', ...
    kernelwidth, varargin{:});
  frequency = frequency*length(times)/length(stimtimes);
else
  frequency = [];
  bintimes = [];
end
