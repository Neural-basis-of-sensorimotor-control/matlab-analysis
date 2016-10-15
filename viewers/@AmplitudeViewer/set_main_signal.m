function set_main_signal(obj, signal)

set_main_signal@SequenceViewer(obj, signal);

signal = obj.main_signal;

if isempty(signal)
	obj.set_amplitude([]);
else
	ampls = signal.get_ampls(obj.tmin,obj.tmax);
	if ~ampls.n
		obj.set_amplitude([]);
	elseif isempty(obj.amplitude)
		obj.set_amplitude(ampls.get(1));
	elseif ampls.contains(obj.amplitude)
		obj.set_amplitude(obj.amplitude);
	elseif sc_contains(ampls.values('tag'),obj.amplitude.tag)
		obj.set_amplitude(ampls.get('tag',obj.amplitude.tag));
	else
		obj.set_amplitude(ampls.get(1));
	end
end

end
