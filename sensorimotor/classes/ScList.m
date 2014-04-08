classdef ScList < handle
    properties (SetObservable)
        list
    end
    
    properties (Dependent)
        n
    end
    
    methods
        
        function add(obj, val)
            if ~obj.n
                obj.list = val;
            else
                obj.list(obj.n+1) = val;
            end
        end
        
        function remove(obj, item)
            obj.list(obj.indexof(item)) = [];
        end
        
        function listobject = get(obj,index, val)
            if nargin==2
                listobject = obj.list(index);
            else
                property = index;
                index = cellfun(@(x) compare_fcn(x, val), {obj.list.(property)});
                listobject = obj.list(index);
            end
        end
        
        function object_exists = has(obj,property,val)
            if ~obj.n
                object_exists = false;
            else
                object_exists = ~isempty(obj.get(property,val));
            end
        end
        
        function exists = contains(obj, item)
            exists = 0;
            for k=1:obj.n
                if obj.get(k)==item
                    exists = true;
                    return
                end
            end
        end
        
        function vals = values(obj, property)
            if isempty(obj.list)
                vals = {};
            else
                vals = {obj.list.(property)};
            end
        end
        
        function index = indexof(obj,item)
            index = -1;   
            for k=1:obj.n
                if obj.get(k)==item
                    index = k;
                    return
                end
            end
        end
        
        function n = get.n(obj)
            n = numel(obj.list);
        end
    end
end

function same = compare_fcn(value1, value2)
if isnumeric(value1)
    same = value1 == value2;
elseif ischar(value1)
    same = strcmp(value1,value2);
end
end