classdef NcSweep < NcChild
    properties
        v
        rising_edge
    end
    properties (Dependent)
        v_binned
    end
    methods
        function ret = get.v_binned(obj)
           n = length(obj.time_binned);
           ret = zeros(n,1);
           for k=1:n
               ret(k) = mean(obj.v((k-1)*obj.binwidth+(1:obj.binwidth)));
           end
        end
    end
end