function trigger_parents = get_trigger_parents(obj)

trigger_parents = {};

if isempty(obj.file)
  return
end

signals = obj.get_signals();
tmin    = obj.sequence.tmin;
tmax    = obj.sequence.tmax;

for i=1:length(signals)
  
  tmp_signal      = signals(i);
  
  for j=1:tmp_signal.waveforms.n
    
    if ~isempty(tmp_signal.waveforms.get(j).gettimes(tmin, tmax))
      
      trigger_parents = add_to_list(trigger_parents, tmp_signal);
      continue
      
    end
    
  end
end

stims = obj.file.stims.list;

for i=1:length(stims)
  
  tmp_stim = get_item(stims, i);
  
  if tmp_stim.istrigger && ~isempty(tmp_stim.gettimes(tmin, tmax))
    
    trigger_parents = add_to_list(trigger_parents, obj.file);
    break
    
  end
  
end

for i=1:length(stims)
  
  tmp_stim = get_item(stims, i);
  
  if ~tmp_stim.istrigger
    
    for j=1:tmp_stim.triggers.n
      
      if ~isempty(tmp_stim.triggers.get(j).gettimes(tmin, tmax))
        
        trigger_parents = add_to_list(trigger_parents, tmp_stim);
        break
        
      end
      
    end
  end
end

end