function waveforms = get_waveforms(obj)

if isempty(obj.signal1)
  waveforms = [];
else
  waveforms = obj.signal1.waveforms.list;
end

end
