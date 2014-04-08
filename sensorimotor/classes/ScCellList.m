classdef ScCellList < handle
    %Linked list and hash set that can hold multiple object types 
    properties
        cell_list = {}
    end
    
    properties (Dependent)
        n
    end
    
    methods
        function add(obj, val)
            obj.cell_list(obj.n+1) = {val};
        end
        
        function listobject = get(obj,index, val)    
            if nargin==2
                listobject = obj.cell_list{index};
            else
                property = index;
                index = find(cellfun(@(x) compare_fcn(x, property, val), obj.cell_list));
                listobject = obj.cell_list{index};
            end
        end
        
        function n = get.n(obj)
            n = numel(obj.cell_list);
        end
        
        function vals = values(obj,property)
            if ~obj.n
                vals = {};
            else
                vals = cell(obj.n,1);
                for i=1:obj.n
                    vals(i) = {obj.get(i).(property)};
                end
            end
        end
        
        function exists = contains(obj,item)
            exists = false;
            for k = obj.cell_list
                if item == k{1}
                    exists = true;
                    return
                end
            end
        end
        
        function list = sublist(obj, pos)
            if islogical(pos)
                if numel(pos)~=obj.n
                    error('For logical indexing, arrays must have same size');
                end
                pos = find(pos);    
            end
            list = ScCellList();
            for k=1:numel(pos)
                list.add(obj.get(pos(k)));
            end 
        end
        
    end
end

function same = compare_fcn(listobject, property, value1)
if isnumeric(value1)
    same = value1 == listobject.(property);
elseif ischar(value1)
    same = strcmp(value1,listobject.(property));
end
end