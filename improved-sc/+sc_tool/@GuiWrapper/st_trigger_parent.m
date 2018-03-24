function st_trigger_parent(obj, ~, val)

triggerparents = obj.get_triggerparents();

obj.trigger_parent = triggerparents{val};

end