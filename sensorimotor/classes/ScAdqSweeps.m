classdef ScAdqSweeps < ScEvent & ScTrigger
    properties
        nbrofsweeps
        sweepwidth
        tag = 'ADQ sweep'
    end
    
    properties (Dependent)
        istrigger
    end
    
    methods
        function obj = ScAdqSweeps(nbrofsweeps, sweepwidth)
            obj.nbrofsweeps = nbrofsweeps;
            obj.sweepwidth = sweepwidth;
        end
        
        function sc_loadtimes(obj)
            obj.times = -obj.sweepwidth/2 + (1:obj.nbrofsweeps)'*obj.sweepwidth;
        end
        
        function istrigger = get.istrigger(~)
            istrigger = true;
        end
    end
end