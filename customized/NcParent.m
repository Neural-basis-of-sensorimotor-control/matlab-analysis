classdef NcParent < handle
    methods (Abstract)
        ret = vals(obj,property)
    end
    properties (Dependent)
        v_binned
    end
    methods
        function ret = get.v_binned(obj)
            ret = cell2mat(obj.vals('v_binned'));
        end

    end
end