function set_sequence(obj,sequence)
obj.sequence = sequence;
if ~isempty(sequence) && sequence.signals.n
    if isempty(obj.main_signal) || ~sequence.contains(obj.main_signal)
        str = obj.sequence.signals.values('tag');
        val = find(cellfun(@(x) strcmpi(x,'patch'),str),1);
        if isempty(val)
            obj.main_channel.signal = obj.sequence.signals.get(1);
        else
            obj.main_channel.signal = obj.sequence.signals.get(val);
        end        
    end
else
    obj.set_sequence([]);
end
end