function set_main_signal(obj, signal)

if isnumeric(signal)
	signal = obj.file.signals.get(signal);
elseif ischar(signal)
	signal = obj.file.signals.get('tag', signal);
end

obj.main_channel.signal = signal;

end