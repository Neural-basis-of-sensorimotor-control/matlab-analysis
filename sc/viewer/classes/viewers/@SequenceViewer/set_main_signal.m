function set_main_signal(obj, signal)

if isempty(obj.file)
  signal = [];
else
  signal = get_item(obj.file.signals.list, signal);
end

obj.main_channel.signal = signal;

end