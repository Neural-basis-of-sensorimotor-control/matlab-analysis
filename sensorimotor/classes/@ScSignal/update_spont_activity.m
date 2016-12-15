function [avg_spont_activity, std_spont_activity] = ...
  update_spont_activity(signal, psps_str, patterns_str, min_latency, max_latency)

spont_activity = nan(size(patterns_str));
response_range = max_latency - min_latency;

for i=1:length(patterns_str)
  fprintf('Processing %d out of %d patterns\n', i, length(patterns_str));
  
  nbr_of_automatic_detections = 0;
  nbr_of_time_intervals = 0;
  
  trigger = signal.parent.gettriggers(0, inf).get('tag', ...
    patterns_str{i});
  triggertimes = trigger.gettimes(0, inf);
  
  for j=2:length(triggertimes)
    for tstop=triggertimes(j):-response_range:(triggertimes(j)-.5)
      tstart = tstop - response_range;
      
      nbr_of_time_intervals = nbr_of_time_intervals + 1;
      
      for k=1:length(psps_str)
        psp = get_item(signal.waveforms.cell_list, psps_str{k});
        if ~isempty(psp) && psp.spike_is_detected(tstart, tstop)
          nbr_of_automatic_detections = nbr_of_automatic_detections + 1;
          continue
        end
      end
    end
  end
  
  spont_activity(i) = nbr_of_automatic_detections/...
    nbr_of_time_intervals;
end

signal.userdata.avg_spont_activity = mean(spont_activity);
signal.userdata.std_spont_activity = std(spont_activity);

if nargout>=1
  avg_spont_activity = signal.userdata.avg_spont_activity;
end

if nargout>=2
    std_spont_activity = signal.userdata.std_spont_activity;
end

end