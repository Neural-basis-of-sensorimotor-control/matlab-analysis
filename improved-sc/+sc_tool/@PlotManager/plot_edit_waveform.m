function plot_edit_waveform(obj)

if isempty(obj.modify_waveform)
  
  while isempty(obj.waveform)
    
    obj.help_text = sprintf(['Write waveform tag in command prompt\n' ...
      'Leave blank to abort']);
    tag = input(': ', 's');
    
    if isempty(tag)
      
      obj.help_text = '';
      obj.modify_waveform = [];
      obj.plot_mode = sc_tool.PlotModeEnum.plot_sweep;
      
      return
      
    end
    
    if any(cellfun(@(x) strcmp(x, tag), obj.signal1.waveforms.values('tag')))
      
      obj.help_text = 'Name already exists';
      
    else
      
      waveform = ScWaveform(obj.signal1, tag, []);
      obj.signal1.waveforms.add(waveform);
      obj.waveform = waveform;
      obj.has_unsaved_changes = true;
      
    end
    
  end
  
  obj.modify_waveform = ModifyWaveform(obj.signal1_axes, obj.signal1, ...
    obj.waveform);
  
  obj.plot_sweep();
  obj.modify_waveform.init_plot();
  
end

end

