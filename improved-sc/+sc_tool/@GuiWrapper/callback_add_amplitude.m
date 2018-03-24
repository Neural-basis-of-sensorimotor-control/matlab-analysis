function callback_add_amplitude(obj, ~, ~)

if isempty(obj.trigger)
  
  obj.help_text('Select parent trigger first');
  obj.plot_mode = sc_tool.PlotModeEnum.plot_sweep;
  return
  
end

obj.amplitude = [];

while isempty(obj.amplitude)
  
  obj.help_text = sprintf(['Write amplitude tag in command prompt\n' ...
    'Leave blank to abort']);
  tag = input(': ', 's');
  
  if isempty(tag)
    
    obj.help_text = '';
    obj.plot_mode = sc_tool.PlotModeEnum.plot_sweep;
    
    return
    
  end
  
  if any(cellfun(@(x) strcmp(x, tag), obj.signal1.amplitudes.values('tag')))
    
    obj.help_text = 'Name already exists';
    
  else
    
    amplitude = ScAmplitude(obj.sequence, obj.signal1, obj.trigger,  ...
      {'t1','v1','t2','v2'}, tag, 0);
    obj.signal1.amplitudes.add(amplitude);
    obj.amplitude = amplitude;
    obj.plot_mode = sc_tool.PlotModeEnum.plot_amplitude;
    obj.has_unsaved_changes = true;
    
  end
  
end

end
