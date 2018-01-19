function set_amplitude(obj, amplitude)

if ~isempty(amplitude)
  
  if isnumeric(amplitude)
    
    amplitudes = obj.get_amplitudes();
    amplitude = amplitudes(amplitude);
    
  elseif ischar(amplitude)
    
    amplitudes = obj.get_amplitudes();
    amplitude = get_item(amplitudes, 'tag', amplitude);
    
  end
  
end

obj.amplitude = amplitude;

end