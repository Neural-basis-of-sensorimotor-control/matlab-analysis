function times = sc_perieventtimes(stimtimes,spiketimes,pretrigger,posttrigger)
%times = sc_perieventtimes(stimtimes,spiketimes,pretrigger,posttrigger)
if size(stimtimes,1)>1,     stimtimes = stimtimes';     end
if size(spiketimes,2)>1,    spiketimes = spiketimes';   end
if ~numel(stimtimes) || ~numel(spiketimes)
  times = [];
else
  times = bsxfun(@minus,spiketimes,stimtimes);
  times = times(times>=pretrigger & times<=posttrigger);
end
end
