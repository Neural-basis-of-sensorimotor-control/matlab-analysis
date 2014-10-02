classdef ObjectList < handle
    properties
        list
    end
    properties (Dependent)
        n
    end
    methods
        function obj = ObjectList
            obj.list = {};
        end
        function n = get.n(obj)
            n = numel(obj.list);
        end
        function add(obj,val)
            if ~obj.n
                obj.list = {val};
            else
                obj.list(obj.n+1) = {val};
            end
        end
        function val = subsref(obj,s)
            val = obj.list{s.field};
        end
    end
end