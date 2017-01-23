function set_trigger(obj, val)

if isempty(obj.triggers)
  val = [];
else
  val = get_item(obj.triggers, val);
end

obj.trigger = val;

if ~isempty(obj.triggertimes)
	obj.sweep = 1;
else
	obj.sweep = [];
end

end