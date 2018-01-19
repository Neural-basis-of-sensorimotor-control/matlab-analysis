function set_trigger_tag(obj, trigger_tag)

obj.trigger_tag = trigger_tag;

if ~isempty(obj.trigger_tag)
  
  obj.trigger_times = obj.trigger_parent.triggers.get('tag', obj.trigger_tag). ...
    gettimes(obj.sequence.tmin, obj.sequence.tmax);
  
else
  
  obj.trigger_times = [];

end

obj.set_trigger_indx(min(1, length(obj.trigger_times)));

end