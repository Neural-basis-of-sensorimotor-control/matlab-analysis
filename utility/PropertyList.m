classdef PropertyList < ObjectList
    properties
        property
    end
    properties (Dependent)
        values
    end
    methods
        function obj = PropertyList(property)
            obj@ObjectList();
            obj.property = property;
        end
        function values = get.values(obj)
            values = cell(obj.n,1);
            for k=1:obj.n
                values(k) = {obj(k).(obj.property)};
            end
        end
    end
end