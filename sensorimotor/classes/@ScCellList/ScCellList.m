classdef ScCellList < handle
  %Linked list and hash set that can hold multiple object types
  properties
    cell_list = {}
  end

  properties (Dependent)
    n
    list
  end

  methods

    function add(obj, val)
      obj.cell_list(obj.n+1) = {val};
    end


    %if nargin == 2
    %   index   index in list
    %if nargin == 3
    %   index   property name (string)
    %   val     desired value of property
    function listobject = get(obj,index, val)
      if nargin==2
        listobject = obj.cell_list{index};
      else
        property = index;
        index = cellfun(@(x) compare_fcn(x, property, val), obj.cell_list);
        if ~nnz(index)
          listobject = [];
        else
          listobject = obj.cell_list{index};
        end
      end
    end


    %if nargin == 2
    %   item   index in list
    %if nargin == 3
    %   item    property name (string)
    %   val     desired value of property
    function remove(obj, item, value)
      if nargin == 2
        index = obj.indexof(item);
        obj.cell_list(index) = [];
      else
        prop = item;
        index = obj.indexof(prop,value);
        obj.cell_list(index) = [];
      end
    end


    %If list contains reference to item, then replace item
    %by new_item in list. Otherwise append newitem to list		
    function update_with_item(obj, item, new_item)
      % if object exists then update
      if obj.contains(item)
        index = obj.indexof(item);
        obj.list(index) = {new_item};
      else
        % if item does not exists then add it
        obj.add(new_item);
      end
    end


    %Return true if there is an object with property property and value
    %val
    function object_exists = has(obj,property,val)
      if ~obj.n
        object_exists = false;
      else
        object_exists = ~isempty(obj.get(property,val));
      end
    end


    %Return true if there is a reference to item in list
    function exists = contains(obj,item)
      exists = false;
      for k = obj.cell_list
        if item == k{1}
          exists = true;
          return
        end
      end
    end


    %get all values of a specific property, as a cell array
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

    %If nargin == 2
    %return index of item in list
    %if nargin == 3
    %return index of item with property item and value value
    function index = indexof(obj,item,value)
      index = -1;
      if nargin==2
        for k=1:obj.n
          if obj.get(k)==item
            index = k;
            return
          end
        end
      else
        prop = item;
        for k=1:obj.n
          if compare_fcn(obj.get(k), prop, value)
            index = k;
            return
          end
        end
      end
    end


    function n = get.n(obj)
      n = numel(obj.cell_list);
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



    %Add item to list att position index
    function insert_at(obj, index, item)
      newlist = cell(obj.n+1,1);
      for k=1:index-1
        newlist{k} = obj.remove_at(1);
      end
      newlist(index) = {item};
      for k=1:obj.n
        newlist(index+k) = obj.remove_at(1);
      end
      obj.cell_list = newlist;
    end

    %Replace item at index with this item
    function replace_at(obj, index, item)
      obj.cell_list(index) = {item};
    end

    function item = remove_at(obj,index)
      item = obj.cell_list{index};
      for k=index:obj.n-1
        obj.cell_list(k) = obj.cell_list(k+1);
      end
      obj.cell_list = obj.cell_list(1:obj.n-1);
    end

    function val = get.list(obj)

      val = [];

      for i=1:obj.n
        val = [val; obj.get(i)]; %#ok<AGROW>
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
