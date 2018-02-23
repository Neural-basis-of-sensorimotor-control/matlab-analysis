function triggable = get_triggables(obj)

triggable = {};

for i=1:obj.signals.n
  
  signal = obj.signals.get(i);
  
  if signal.waveforms.n > 0
    triggable = add_to_list(triggable, signal);
  end
  
end

triggable = concat_list(triggable, obj.stims.cell_list);
triggable = concat_list(triggable, obj.textchannels.cell_list);

end