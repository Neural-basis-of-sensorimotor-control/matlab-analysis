function val = getSelectedTriggerTimes(obj)

if isempty(obj.triggerTimes)
  val = [];
else
  val = obj.triggerTimes(obj.triggerIndx);
end

end