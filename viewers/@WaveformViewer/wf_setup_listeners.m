function wf_setup_listeners(obj)
addlistener(obj,'main_channel','PostSet',@main_channel_listener);

    function main_channel_listener(~,~)
        addlistener(obj.main_channel,'signal','PostSet',@main_channel_signal_listener);
        
        function main_channel_signal_listener(~,~)
            signal = obj.main_channel.signal;
            if ~isempty(signal)
                if ~isempty(obj.waveform) && signal.waveforms.contains(obj.waveform)
                    obj.waveform = obj.waveform;
                elseif signal.waveforms.n
                    obj.waveform = signal.waveforms.get(1);
                else
                    obj.waveform = [];
                end
            end
        end
    end
end