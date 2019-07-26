function [sweep, time, rawSweep] = getSweep(obj)

triggerTime   = obj.getSelectedTriggerTimes();

[sweep, time] = sc_get_sweeps(obj.v, 0, triggerTime, obj.pretrigger, ...
  obj.posttrigger, obj.signal.dt);

if ~isempty(obj.rectificationPoint)
  
  [~, indx] = min(abs(time - obj.rectificationPoint));
  
  for i=1:size(sweep, 2)
    sweep(:,i) = sweep(:, i) - sweep(indx, i);
  end
end


if ~isempty(obj.vRaw) && nargout>=3
  rawSweep      = sc_get_sweeps(obj.vRaw, 0, triggerTime, obj.pretrigger, ...
    obj.posttrigger, obj.signal.dt);
else
  rawSweep = [];
end

end