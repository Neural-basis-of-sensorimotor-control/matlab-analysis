function set_signal1(obj, signal1)

if isnumeric(signal1)
  
  signals = obj.get_signals();
  signal1 = signals(signal1);

end

obj.signal1 = signal1;

if isempty(obj.signal1)
  
  waveform    = [];
  amplitude   = [];
  
else
  
  waveform  = get_set_val(obj.get_waveforms(),  obj.waveform);
  amplitude = get_set_val(obj.get_amplitudes(), obj.amplitude);

end

obj.set_waveform(waveform);
obj.set_amplitude(amplitude);

end