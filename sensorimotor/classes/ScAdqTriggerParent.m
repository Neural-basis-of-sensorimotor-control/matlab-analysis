classdef ScAdqTriggerParent < ScTriggerParent
    properties
        tag = 'ADQ file';
    end
    methods
        function obj = ScAdqTriggerParent()
            obj@ScTriggerParent();
            obj.triggers = ScList();
        end
        function sc_loadtimes(obj)
            for k=1:obj.triggers.n
                obj.triggers.get(k).sc_loadtimes();
            end
        end
        function sc_clear(obj)
            for k=1:obj.triggers.n
                obj.triggers.get(k).sc_clear();
            end
        end
        
    end
end