function av_setup_listeners(obj)
addlistener(obj,'main_channel','PostSet',@main_channel_listener);

    function main_channel_listener(~,~)
        addlistener(obj.main_channel,'signal','PostSet',@main_channel_signal_listener);
        
        function main_channel_signal_listener(~,~)
            signal = obj.main_channel.signal;
            if isempty(main_signal)
                obj.amplitude = [];
            else
                ampls = signal.get_ampls(obj.tmin,obj.tmax);
                if ~ampls.n
                    obj.amplitude = [];
                elseif isempty(obj.amplitude)
                    obj.amplitude = ampls.get(1);
                elseif ampls.contains(obj.amplitude)
                    obj.amplitude = obj.amplitude;
                elseif sc_contains(ampls.values('tag'),obj.amplitude.tag)
                    obj.amplitude = ampls.get('tag',obj.amplitude.tag);
                else
                    obj.amplitude = ampls.get(1);
                end
            end
        end
    end
end