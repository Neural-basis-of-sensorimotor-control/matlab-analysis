classdef ScClockTriggerParent < ScTriggerParent
    properties
        tag
        sequence
    end
    methods
        function obj = ScClockTriggerParent(sequence)
            obj@ScTriggerParent();
            obj.tag = 'No trigger';
            obj.sequence = sequence;
            obj.sc_loadtimes();
        end
        function sc_loadtimes(obj)
            obj.triggers = ScCellList();
            trg = ScSpikeTrain('seconds',(ceil(obj.sequence.tmin):floor(obj.sequence.tmax))');
            obj.triggers.add(trg);
            trg = ScSpikeTrain('100 ms',...
                (sc_ceil(obj.sequence.tmin,.1):.1:sc_floor(obj.sequence.tmax,.1))');
            obj.triggers.add(trg);
        end
        function sc_clear(obj)
            obj.triggers = ScCellList();
        end
    end
end