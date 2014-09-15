function setup_listeners(obj)

addlistener(obj,'experiment','PostSet',@experiment_listener);
addlistener(obj,'file','PostSet',@file_listener);
addlistener(obj,'sequence','PostSet',@sequence_listener);
addlistener(obj,'main_channel','PostSet',@main_channel_listener);
addlistener(obj,'show_digital_channels','PostSet',@show_digital_channels_listener);
addlistener(obj,'show_histogram','PostSet',@show_histogram_listener);
addlistener(obj,'main_axes','PostSet',@main_axes_listener);
addlistener(obj,'main_signal','PostSet',@main_signal_listener);
addlistener(obj,'zoom_on','PostSet',@zoom_on_listener);
addlistener(obj,'pan_on','PostSet',@pan_on_listener);

% addlistener(obj,'nbr_of_analog_channels','PostSet',@set_nbr_of_analog_channels_listener);
% addlistener(obj,'nbr_of_analog_channels','PreGet',@get_nbr_of_analog_channels_listener);

    function experiment_listener(~,~)
        if ~isempty(obj.experiment) && obj.experiment.n
            if ~isempty(obj.file)
                if obj.experiment.contains(obj.file)
                    obj.file = obj.file;
                else
                    obj.file = obj.experiment.get(1);
                end
            else
                obj.file = obj.experiment.get(1);
            end
        else
            obj.file = [];
        end
    end

    function file_listener(~,~)
        if ~isempty(obj.file) && obj.file.n
            if ~isempty(obj.sequence)
                if obj.file.contains(obj.sequence)
                    obj.sequence = obj.sequence;
                else
                    obj.sequence = obj.file.get(1);
                end
            else
                obj.sequence = obj.file.get(1);
            end
        else
            obj.sequence = [];
        end
    end

    function sequence_listener(~,~)
        fprintf('Entering %s\\sequence_listener\n',mfilename);
        if ~isempty(obj.sequence)
            for k=1:obj.analog_channels.n
                signal = obj.analog_channels.get(k).signal;
                if isempty(signal) || ~obj.sequence.signals.contains(signal)
                    obj.analog_channels.get(k).signal = obj.sequence.signals.get(k);
                end
            end
            if obj.analog_channels.n
                if isempty(obj.main_channel)
                    obj.main_channel = obj.analog_channels.get(1);
                end
            end
        end
        fprintf('\tExiting %s\\sequence_listener\n',mfilename);
    end

    function main_channel_listener(~,~)
        fprintf('Entering %s\\main_channel_listener\n',mfilename);
        obj.main_signal = obj.main_channel.signal;
        obj.main_axes = obj.main_channel.ax;
        fprintf('\tExiting %s\\main_channel_listener\n',mfilename);
    end

    function main_signal_listener(~,~)
        obj.main_channel.clear_data();
        obj.main_channel.signal = obj.main_signal;
        if ~isempty(obj.waveform) && obj.main_signal.waveforms.contains(obj.waveform)
            obj.waveform = obj.waveform;
        elseif obj.main_signal.waveforms.n
            obj.waveform = obj.main_signal.get(1);
        else
            obj.waveform = [];
        end
    end

    function main_axes_listener(~,~)
        if ~isempty(obj.main_axes)
            z = zoom(obj.main_axes);
            set(z,'ActionPostCallback',@xaxis_listener);
            p = pan(obj.current_view);
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
            pan(obj.main_axes,'on');
        else
            pan(obj.main_axes,'off');
        end
    end

    function show_digital_channels_listener(~,~)
        if obj.show_digital_channels && isempty(obj.digital_channels)
            obj.digital_channels = DigitalAxes(obj);
        elseif ~obj.show_digital_channels && ~isempty(obj.digital_channels)
            obj.digital_channels = [];
        end
    end

    function show_histogram_listener(~,~)
        if obj.show_histogram && isempty(obj.histogram)
            obj.histogram = HistogramChannel(obj);
        elseif ~obj.show_histogram && ~isempty(obj.histogram)
            obj.histogram = [];
        end
    end
%     function set_nbr_of_analog_channels_listener(~,~)
%         nbr = obj.plots.n;
%         if obj.show_digital_channels
%             nbr = nbr-1;
%             offset = 1;
%         else
%             offset = 0;
%         end
%         if obj.show_histogram
%             nbr = nbr-1;
%             upperoffset = 1;
%         else
%             upperoffset = 0;
%         end
%         for k=nbr+1:obj.nbr_of_analog_channels
%             obj.plots.insert_at(k+offset,AnalogAxes(obj,obj.sequence.signals.get(k)));
%         end
%         while nbr>obj.nbr_of_analog_channels
%             obj.plots.remove_at(obj.plots.n-upperoffset);
%         end
%     end
%
%     function get_nbr_of_analog_channels_listener(~,~)
%         nbr = obj.plots.n;
%         if obj.show_digital_channels
%             nbr = nbr-1;
%         end
%         if obj.show_histogram
%             nbr = nbr-1;
%         end
%         obj.nbr_of_analog_channels = nbr;
%     end

end