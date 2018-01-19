function set_waveform(obj, waveform)

if ~isempty(waveform)
  
  if isnumeric(waveform)
  
    waveforms = obj.get_waveforms();
    waveform = waveforms(waveform);
  
  elseif ischar(waveform)
  
    waveforms = obj.get_waveforms();
    waveform = get_item(waveforms, 'tag', waveform);
  
  end

end

obj.waveform = waveform;

end