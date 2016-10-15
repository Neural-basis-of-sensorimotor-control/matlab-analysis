function set_main_signal(obj, signal)

set_main_signal@SequenceViewer(obj, signal);
signal = obj.main_signal;

if ~isempty(signal)
	if ~isempty(obj.waveform) && signal.waveforms.contains(obj.waveform)
		obj.set_waveform(obj.waveform);
	elseif signal.waveforms.n
		obj.set_waveform(signal.waveforms.get(1));
	else
		obj.set_waveform([]);
	end
end

if isempty(obj.main_signal)
	obj.set_waveform([]);
elseif ~obj.main_signal.waveforms.n
	obj.set_waveform([]);
elseif isempty(obj.waveform)
	obj.set_waveform(obj.main_signal.waveforms.get(1));
elseif obj.main_signal.waveforms.has('tag', obj.waveform.tag)
	obj.set_waveform(obj.main_signal.waveforms.get('tag', obj.waveform.tag));
else
	obj.set_waveform(obj.main_signal.waveforms.get(1));
end

end
