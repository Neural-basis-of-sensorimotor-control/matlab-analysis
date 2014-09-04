classdef CascadeList < handle
    properties
        list
    end
    
    properties (Dependent)
        n
        last_visible_item
    end
    
    methods
        function add(obj, item)
            item.parent = obj;
            if isempty(obj.list)
                obj.list = item;
            else
                obj.list(obj.n+1) = item;
            end
        end
        
        function item = get(obj,index)
            item = obj.list{index};
        end
        
        function initialize(obj)
            for k=1:obj.n
                obj.get(k).initalize();
            end
        end
        
        function update(obj)
           obj.last_visible_item.update();
           if obj.last_visible_item.updated
               obj.last_visible_item.setvisible(true);
           end
        end
        
        function n = get.n(obj)
            n = numel(obj.list);
        end
        
        function item = get.last_visible_item(obj)
            item = [];
            for k=1:obj.n
                visible_str = get(obj.get(k),'visible');
                if strcmp(visible_str,'off')
                    return
                else
                    item = obj.get(k);
                end
            end
        end
    end
end