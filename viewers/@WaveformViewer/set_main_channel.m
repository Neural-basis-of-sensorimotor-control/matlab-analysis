function set_main_channel(obj, signal)

main_channel_listener@SequenceViewer(obj, signal);

if ~isempty(signal)
	if ~isempty(obj.waveform) && signal.waveforms.contains(obj.waveform)
		obj.set_waveform(obj.waveform);
	elseif signal.waveforms.n
		obj.set_waveform(signal.waveforms.get(1));
	else
		obj.set_waveform([]);
	end
end

end