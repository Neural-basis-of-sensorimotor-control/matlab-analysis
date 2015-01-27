function [frequency, bintimes] = sc_kernelfreq(stimtimes,spiketimes,pretrigger,posttrigger,binwidth,varargin)
times = temp_neuro.sc_perieventtimes(stimtimes,spiketimes,pretrigger,posttrigger);
bintimes = pretrigger:binwidth:posttrigger;
if ~isempty(times)
    [frequency,bintimes] = ksdensity(times,bintimes,varargin{:});
    frequency = frequency*length(times)/length(stimtimes);
else
    frequency = [];
    bintimes = [];
end