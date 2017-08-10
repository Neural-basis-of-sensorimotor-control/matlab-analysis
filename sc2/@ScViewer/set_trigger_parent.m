function set_trigger_parent(obj, val)

obj.triggerparent = val;

if isempty(val)
  trigger_tag = [];
else
  trigger_tag = get_set_val(obj.trigger_parent.get_trigger_tags(), obj.trigger, 1);
end

obj.set_trigger_tag(trigger_tag);

end