function callback_next_trigger(obj, ~, ~)

if isempty(obj.trigger)
  obj.trigger_time = obj.trigger_time + obj.trigger_incr;
else
  obj.trigger_indx = obj.trigger_indx + obj.trigger_incr;
end

end