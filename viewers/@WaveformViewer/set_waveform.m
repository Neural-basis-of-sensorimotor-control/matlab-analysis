function set_waveform(obj, val)

if isempty(val)
  obj.waveform = val;
else
  obj.waveform = get_item(obj.main_signal.waveforms, val);
end

end