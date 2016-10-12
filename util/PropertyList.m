classdef PropertyList < handle
  properties
    list
    tag_str
  end
  properties (Dependent)
    n
    values
  end
  methods
    function obj = PropertyList(tag_str)
      obj.tag_str = tag_str;
      obj.list = {};
    end
    function add(obj,item)
      if ~isfield(item,obj.tag_str) && ~sc_contains(properties(item),'clocktime')
        error('Item lacks field %s',obj.tag_str);
      elseif sc_contains(obj.values,item.(obj.tag_str))
        error('List already contains list with value %s of tag %s',...
          obj.tag_str,item.(obj.tag_str));
        elseif ~obj.n
          obj.list = {item};
        else
          obj.list(obj.n+1) = {item};
        end
      end
      function item = get(obj,index)
        if isnumeric(index)
          item = obj.list{index};
        else
          item = obj.list{sc_cellfind(obj.values,index)};
        end
      end
      function values = get.values(obj)
        values = cell(size(obj.list));
        for k=1:obj.n
          values(k) = {obj.get(k).(obj.tag_str)};
        end
      end
      function n = get.n(obj)
        n = length(obj.list);
      end
    end
  end
