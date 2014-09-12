classdef CascadeList < handle
    properties
        list
    end
    
    properties (Dependent)
        n
        last_enabled_item
    end
    
    methods
        function add(obj, item)
            if isempty(obj.list)
                obj.list = {item};
            else
                obj.list(obj.n+1) = {item};
            end
        end
        
        function item = get(obj,index)
            item = obj.list{index};
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
        
        function initialize(obj)
            for k=1:obj.n
                obj.get(k).initalize();
            end
        end
        
        function n = get.n(obj)
            n = numel(obj.list);
        end
        
        
        function item = get.last_enabled_item(obj)
            item = [];
            for k=1:obj.n
                if ~obj.get(k).enabled
                    return
                else
                    item = obj.get(k);
                end
            end
        end
    end
end