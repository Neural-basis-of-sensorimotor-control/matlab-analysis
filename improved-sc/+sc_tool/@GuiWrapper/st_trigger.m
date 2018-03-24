function  st_trigger(obj, ~, val)

triggers = obj.trigger_parent.get_triggers();
obj.trigger = triggers(val);

end