function [time, sweep] = sc_perievent_sweep(trigger_time, spike_time, pretrigger, posttrigger)
%t      Nx1 array of spike times rel to closest trigger time
%sweep  Nx1 array of sweep number, indexed from 1 ... numel(trigger_time)

if isempty(trigger_time)
  time = [];
  
  if nargout>1
    sweep = [];
  end
  
  return
end

time = nan(10*numel(trigger_time),1);

if nargout>1
  sweep = nan(size(time));
end

counter = 0;

for i=1:numel(trigger_time)
  
  tmp_time = spike_time(spike_time > trigger_time(i) + pretrigger & ...
    spike_time < trigger_time(i) + posttrigger )- trigger_time(i);
  
  time(counter+1:counter+numel(tmp_time)) = tmp_time;
  
  if nargout>1
    sweep(counter+1:counter+numel(tmp_time)) = i*ones(size(tmp_time));
  end
  
  counter = counter + numel(tmp_time);
end

time = time(1:counter);

if nargout>1
  sweep = sweep(1:counter);
end

end