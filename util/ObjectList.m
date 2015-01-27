classdef ObjectList < handle
    properties
        list
    end
    properties (Dependent)
        n
    end
    methods
        function obj = ObjectList()
            obj.list = [];
        end
        function add(obj,item)
            if ~obj.n
                obj.list = item;
            else
                obj.list(obj.n+1) = item;
            end
        end
        function item = get(obj,index)
            item = obj.list(index);
        end
        function ret = vals(obj,property)
            ret = {obj.list.(property)};
        end
        function append(obj,newlist)
            for k=1:newlist.n
                obj.list.add(newlist(get(k)));
            end
        end
        function n = get.n(obj)
            n = length(obj.list);
        end
    end
end