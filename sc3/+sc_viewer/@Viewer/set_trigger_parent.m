function set_trigger_parent(obj, trigger_parent)

obj.trigger_parent = trigger_parent;

trigger_tag = get_set_val(trigger_parent.get_trigger_tags(), obj.trigger_tag);

obj.set_trigger_tag(trigger_tag);

end