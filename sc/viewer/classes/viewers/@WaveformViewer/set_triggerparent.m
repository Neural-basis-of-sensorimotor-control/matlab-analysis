function set_triggerparent(obj, val)

obj.triggerparent = val;

if isempty(val)
  trigger = [];
else
  trigger = get_set_val(obj.triggers.cell_list, obj.trigger, 1);
end

obj.set_trigger(trigger);

end