function plot_edit_waveform(obj)

if isempty(obj.modify_waveform)
  
  obj.modify_waveform = ModifyWaveform(obj.signal1_axes, obj.signal1, ...
    obj.waveform);
  obj.plot_sweep();
  obj.modify_waveform.init_plot();

end

end
