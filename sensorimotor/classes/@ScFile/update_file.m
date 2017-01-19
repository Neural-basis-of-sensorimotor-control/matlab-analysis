function update_file(obj, only_waveforms)

for i=1:obj.signals.n
  signal = obj.signals.get(i);
  
  if only_waveforms && ~signal.waveforms.n
    continue
  end
  
  signal.update_continuous_signal(true);
end

end