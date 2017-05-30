function add_waveform(obj, tag, varargin)

waveform = ScWaveform(obj.main_signal, tag, []);

for i=1:2:length(varargin)
  waveform.(varargin{i}) = varargin{i+1};
end

obj.main_signal.waveforms.add(waveform);

obj.has_unsaved_changes = true;

end