function wf_setup_listeners(obj)
addlistener(obj,'main_channel','PostSet',@(~,~) main_channel_listener(obj));
addlistener(obj,'sequence','PostSet',@(~,~) sequence_listener(obj));
addlistener(obj,'triggerparent','PostSet',@(~,~) triggerparent_listener(obj));


    function main_channel_listener(objh)
        addlistener(objh.main_channel,'signal','PostSet',@(~,~) main_channel_signal_listener(objh));
        
        function main_channel_signal_listener(objh)
            signal = objh.main_channel.signal;
            if ~isempty(signal)
                if ~isempty(objh.waveform) && signal.waveforms.contains(objh.waveform)
                    objh.waveform = objh.waveform;
                elseif signal.waveforms.n
                    objh.waveform = signal.waveforms.get(1);
                else
                    objh.waveform = [];
                end
            end
        end
    end

    function sequence_listener(objh)
        if ~isempty(objh.sequence)
            triggerparents = objh.triggerparents;
            if ~triggerparents.n
                objh.triggerparent = [];
            elseif ~isempty(objh.triggerparent) && triggerparents.contains(objh.triggerparent)
                objh.triggerparent = objh.triggerparent;
            else
                objh.triggerparent = triggerparents.get(1);
            end
        else
            objh.triggerparent = [];
        end
    end

    function triggerparent_listener(objh)
        if ~isempty(objh.triggerparent)
%            all_triggers = objh.triggerparent.triggers;%
%            triggers = ScCellList();
            triggers = objh.triggers;
%             for k=1:all_triggers.n
%                 trigg = all_triggers.get(k);
%                 if nnz(trigg.gettimes(objh.tmin,objh.tmax))
%                     triggers.add(trigg);
%                 end
%             end
            if ~triggers.n
                objh.trigger = [];
            elseif ~isempty(objh.trigger) && triggers.contains(objh.trigger)
                objh.trigger = objh.trigger;
            else
                objh.trigger = triggers.get(1);
            end
        else
            objh.trigger = [];
        end
    end
end