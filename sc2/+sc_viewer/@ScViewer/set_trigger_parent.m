function set_trigger_parent(obj, val)

obj.trigger_parent = val;

if isempty(val)
  trigger_tag = [];
else
  trigger_tag = get_set_val(obj.trigger_parent.triggers.values('tag'), ...
    obj.trigger_tag, 1);
end

obj.set_trigger_tag(trigger_tag);

end