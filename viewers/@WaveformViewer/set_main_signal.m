function set_main_signal(obj, signal)

obj.main_channel.signal = signal;

% if isempty(signal) || ~signal.waveforms.n
%   obj.waveform = [];
% else
%   obj.waveform = obj.main_channel.signal.waveforms.get(1);
% end

end