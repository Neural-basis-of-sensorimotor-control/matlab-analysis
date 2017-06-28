function set_main_signal(obj, signal)

set_main_signal@SequenceViewer(obj, signal);
signal = obj.main_signal;

if ~isempty(signal)
  waveform = get_set_val(signal.waveforms.list, obj.waveform);
else
  waveform = [];
end

obj.set_waveform(waveform);

end
