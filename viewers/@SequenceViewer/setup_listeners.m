function setup_listeners(obj)

addlistener(obj,'experiment','PostSet',@experiment_listener);
addlistener(obj,'file','PostSet',@file_listener);
addlistener(obj,'main_signal','PostSet',@main_signal_listener);
addlistener(obj,'main_channel','PostSet',@main_channel_listener);
addlistener(obj,'show_digital_channels','PostSet',@show_digital_channel_listener);
addlistener(obj,'show_histogram','PostSet',@show_histogram_listener);
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

    function main_channel_listener(~,~)
        obj.main_signal = obj.main_channel.signal;
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

    function show_digital_channel_listener(~,~)
        if obj.show_digital_channel && isempty(obj.digital_channels)
            obj.digital_channels = DigitalAxes(obj.gui);
        elseif ~obj.show_digital_channel && ~isempty(obj.digital_channels)
            obj.digital_channels = [];
        end
    end

    function show_histogram_listener(~,~)
        if obj.show_histogram && isempty(obj.histogram)
            obj.histogram = HistogramChannel(obj.gui);
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