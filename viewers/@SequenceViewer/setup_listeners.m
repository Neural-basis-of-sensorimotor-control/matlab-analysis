function setup_listeners(obj)

addlistener(obj,'main_channel','PostSet',@main_channel_listener);
%addlistener(obj,'show_digital_channels','PostSet',@show_digital_channels_listener);
%addlistener(obj,'show_histogram','PostSet',@show_histogram_listener);
addlistener(obj,'digital_channels','PreSet',@digital_channels_listener_pre);
addlistener(obj,'digital_channels','PostSet',@digital_channels_listener_post);
% addlistener(obj,'histogram','PreSet',@histogram_listener_pre);
% addlistener(obj,'histogram','PostSet',@histogram_listener_post);
deletechannel = [];
addlistener(obj,'zoom_on','PostSet',@zoom_on_listener);
addlistener(obj,'pan_on','PostSet',@pan_on_listener);

% addlistener(obj,'nbr_of_analog_channels','PostSet',@set_nbr_of_analog_channels_listener);
% addlistener(obj,'nbr_of_analog_channels','PreGet',@get_nbr_of_analog_channels_listener);

    function main_channel_listener(~,~)
        
        addlistener(obj.main_channel,'signal','PostSet',@main_channel_signal_listener);
        addlistener(obj.main_channel,'ax','PostSet',@main_channel_ax_listener);
        
        function main_channel_signal_listener(~,~)
            if ~isempty(obj.main_channel.signal)
                if ~isempty(obj.waveform) && obj.main_signal.waveforms.contains(obj.waveform)
                    obj.waveform = obj.waveform;
                elseif obj.main_signal.waveforms.n
                    obj.waveform = obj.main_signal.waveforms.get(1);
                else
                    obj.waveform = [];
                end
            end
        end
        
        function main_channel_ax_listener(~,~)
            if ~isempty(obj.main_axes)
                z = zoom(obj.main_axes);
                set(z,'ActionPostCallback',@xaxis_listener);
                p = pan(obj.plot_window);
                set(p,'ActionPostCallback',@xaxis_listener);
            end
            
            function xaxis_listener(~,~)
                obj.xlimits = xlim(gca);%obj.main_axes);
                if obj.xlimits(1) < obj.pretrigger
                    obj.pretrigger = obj.xlimits(1);
                end
                if obj.xlimits(2) > obj.posttrigger
                    obj.posttrigger = obj.xlimits(2);
                end
            end
        end
    end

    function zoom_on_listener(~,~)

        if obj.zoom_on
            obj.pan_on = 0;
            zoom(obj.main_axes,'on');
        else
            zoom(obj.main_axes,'off');
        end
        
    end

    function pan_on_listener(~,~)

        if obj.pan_on
            obj.zoom_on = 0;
            pan(obj.plot_window,'on');%obj.main_axes,'on');
        else
            pan(obj.plot_window,'off');%pan(obj.main_axes,'off');
        end
        
    end


    function digital_channels_listener_pre(~,~)
        if ~isempty(obj.digital_channels)
            deletechannel = obj.digital_channels;
        else
            deletechannel = [];
        end
    end

    function digital_channels_listener_post(~,~)
        if ~isempty(deletechannel) && isobject(deletechannel) && ...
                (isempty(obj.digital_channels) || obj.digital_channels ~= deletechannel)
            delete(deletechannel.ax);
        end
    end


end