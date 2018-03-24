function callback_rm_waveform(obj, ~, ~)

obj.signal1.waveforms.list(equals(obj.signal1.waveforms.list == obj.waveform)) = [];

if obj.signal1.waveforms.n > 0
  obj.waveform = obj.signal1.waveforms.get(1);
else
  obj.waveform = [];
end

end