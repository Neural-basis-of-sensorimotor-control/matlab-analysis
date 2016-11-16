function set_triggerparent(obj, val)

val = get_item(obj.triggerparents.cell_list, val);

obj.triggerparent = val;

trigger = get_set_val(obj.triggers.cell_list, obj.trigger, 1);

obj.set_trigger(trigger);
% 
% 
% if ~isempty(val)
% 	triggers = obj.triggers;
% 	
% 	if ~triggers.n
% 		obj.set_trigger([]);
% 		
% 	elseif isempty(obj.trigger)
% 		obj.set_trigger(triggers.get(1));
% 		
% 	else
% 		tag = obj.trigger.tag;
% 		
% 		if sc_contains(triggers.values('tag'), tag)
% 			obj.set_trigger(triggers.get('tag', tag));
% 		else
% 			obj.set_trigger(triggers.get(1));
% 		end
% 	end
% else
% 	obj.set_trigger([]);
% end

end