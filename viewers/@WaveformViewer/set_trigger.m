function set_trigger(obj, val)

% if isnumeric(val)
% 	val = obj.triggers.get(val);
% elseif ischar(val)
% 	val = obj.triggers.get('tag', val);
% end

val = get_item(obj.triggers.cell_list, val);
obj.trigger = val;

if ~isempty(obj.triggertimes)
	obj.sweep = 1;
else
	obj.sweep = [];
end

end