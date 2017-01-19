function val = get_waveforms(obj)

val = [];

for i=1:obj.signals.n
  signal = obj.signals.get(i);
  
  val = concat_list(val, signal.waveforms.list);
end

end