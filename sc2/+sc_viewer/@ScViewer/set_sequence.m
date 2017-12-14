function set_sequence(obj, sequence)

obj.sequence = sequence;

if ~isempty(sequence) && sequence.signals.n
  
  if isempty(obj.signal1) || ~sequence.signals.contains(obj.signal1)
    
    str = obj.sequence.signals.values('tag');
    ind = find(cellfun(@(x) strcmpi(x,'patch'),str),1);
    
    if isempty(ind)
      obj.set_signal1(obj.sequence.signals.get(1));
    else
      obj.set_signal1(obj.sequence.signals.get(ind));
    end
    
  end
  
  if ~isempty(obj.signal2)
    
    str = obj.sequence.signals.values('tag');
    ind2 = find(cellfun(@(x) strcmpi(x,'patch2'),str),1);
        
    if isempty(ind2)
      obj.set_signal2(obj.sequence.signals.get(2));
    else
      obj.set_signal2(obj.sequence.signals.get(ind2));
    end
    
  end
  
else
  
  obj.set_signal1([]);
  obj.set_signal2([]);

end

if isempty(sequence)
  
  obj.rmwf = [];

else
  
  if ~isempty(obj.signal1)
    
    signal1 = obj.signal1;
    rmwfs   = signal1.get_rmwfs(obj.sequence.tmin, obj.sequence.tmax);
  
    if ~rmwfs.n
      
      obj.set_rmwf([]);
    
    else
      
      if ~isempty(obj.rmwf) && rmwfs.contains(obj.rmwf)
        obj.set_rmwf(obj.rmwf);
      else
        obj.set_rmwf(rmwfs.get(1));
      end
      
    end
  end
end


if ~isempty(obj.sequence)
  
	triggerparents = obj.sequence.gettriggerparents(obj.sequence.tmin, ...
    obj.sequence.tmax);
	
	if ~triggerparents.n
    
		obj.set_trigger_parent([]);
		
	elseif ~isempty(obj.trigger_parent) && triggerparents.contains(obj.trigger_parent)
		
    obj.set_trigger_parent(obj.trigger_parent);
		
  else
    
    str = triggerparents.values('tag');
		
    if sc_contains(str, 'DigMark')
			obj.set_trigger_parent(triggerparents.get('tag','DigMark'));
		else
			obj.set_trigger_parent(triggerparents.get(1));
    end
    
  end
	
else
  
	obj.set_triggerparent([]);

end

end