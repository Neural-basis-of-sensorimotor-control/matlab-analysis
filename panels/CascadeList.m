classdef CascadeList < ScCellList
    
    properties (Dependent)
        last_enabled_item
    end
    
    methods
        
        
        function initialize(obj)
            for k=1:obj.n
                obj.get(k).initalize();
            end
        end
        
        function item = get.last_enabled_item(obj)
            item = [];
            for k=1:obj.n
                item = obj.get(k);
                if ~item.enabled
                    item.dbg_in(mfilename,'get.last_enabled_item',class(item));
                    item.dbg_out(mfilename,'get.last_enabled_item');
                    return
                end
            end
        end
    end
end