function set_triggerparent(obj, val)

obj.triggerparent = val;

if ~isempty(val)
	triggers = obj.triggers;
	
	if ~triggers.n
		obj.set_trigger([]);
		
	elseif isempty(obj.trigger)
		obj.set_trigger(triggers.get(1));
		
	else
		tag = obj.trigger.tag;
		
		if sc_contains(triggers.values('tag'), tag)
			obj.set_trigger(triggers.get('tag', tag));
		else
			obj.set_trigger(triggers.get(1));
		end
	end
else
	obj.set_trigger([]);
end

end