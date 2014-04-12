classdef ScListElement < handle
    %todo: incorporate in ScList and ScCellList
    %index can be replaced by ScList->indexof() in parent class
    properties
        parent
    end
    properties (Dependent)
        index
    end
    methods
        
        function index = get.index(obj)
            index = find(cell2mat(cellfun(@(x) x == obj, {obj.parent.list},'UniformOutput',0)));
        end
        function last = islast(obj)
            last = obj.index == obj.parent.n;
        end
        
        function el = next(obj)
            if obj.islast()
                el = [];
            else
                el = obj.parent.get(obj.index+1);
            end
        end
    end
end