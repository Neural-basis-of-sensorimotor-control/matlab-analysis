function [frequency, bintimes] = sc_perifreq(stimtimes,spiketimes,pretrigger,posttrigger,binwidth)

times = temp_neuro.sc_perieventtimes(stimtimes,spiketimes,pretrigger,posttrigger);
bintimes = pretrigger:binwidth:posttrigger;
if ~isempty(times)
    frequency = histc(times,bintimes);
    frequency = frequency/(numel(stimtimes)*binwidth);
else
    frequency = zeros(size(bintimes));
end

end