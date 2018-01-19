function set_trigger_indx(obj, trigger_indx)

obj.trigger_indx = trigger_indx;

if obj.trigger_indx > 0
  
  obj.set_trigger_time(obj.trigger_times(obj.trigger_indx));
  
end

end