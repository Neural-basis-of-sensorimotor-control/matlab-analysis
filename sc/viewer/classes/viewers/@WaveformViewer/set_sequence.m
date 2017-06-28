function set_sequence(obj, val)

set_sequence@SequenceViewer(obj, val);

if ~isempty(obj.sequence)
	triggerparents = obj.triggerparents;
	
	if ~triggerparents.n
		obj.set_triggerparent([]);
		
	elseif ~isempty(obj.triggerparent) && triggerparents.contains(obj.triggerparent)
		obj.set_triggerparent(obj.triggerparent);
		
	else
		str = triggerparents.values('tag');
		if sc_contains(str,'DigMark')
			obj.set_triggerparent(triggerparents.get('tag','DigMark'));
		else
			obj.set_triggerparent(obj.triggerparents.get(1));
		end
	end
	
else
	obj.set_triggerparent([]);
end

end