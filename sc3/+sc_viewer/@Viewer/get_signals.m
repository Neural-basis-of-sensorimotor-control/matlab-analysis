function signals = get_signals(obj)

if isempty(obj.file)
  signals = [];
else
  signals = obj.file.signals.list;
end

signals = add_to_list(signals, ScSignal.make_empty_class());

end


