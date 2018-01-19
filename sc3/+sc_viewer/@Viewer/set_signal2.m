function set_signal2(obj, signal2)

if isnumeric(signal2)
  signals = obj.get_signals();
  signal2 = signals(signal2);
end

obj.signal2 = signal2;

end