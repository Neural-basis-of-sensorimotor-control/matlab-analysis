function set_signal1(obj, signal1)

obj.signal1 = signal1;

if isempty(obj.signal1)
  
  waveform     = [];
  amplitude    = [];
  remove_spike = [];

else
  
  waveform      = get_set_val(obj.signal1.waveforms.list, obj.waveform);
  amplitude     = get_set_val(obj.signal1.amplitudes.list, obj.amplitude);
  remove_spike  = get_set_val(obj.signal1.remove_waveforms.list, obj.remove_spike);
  
end

obj.set_waveform(waveform);
obj.set_amplitude(amplitude);
obj.set_remove_spike(remove_spike);
  
end