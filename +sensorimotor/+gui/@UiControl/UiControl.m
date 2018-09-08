classdef UiControl < handle
  
  properties
    style
    get_string_fcn
    get_value_fcn
    callback_fcn
    listener_property
    uictrl
    viewer
  end
  
  methods
    function t = create(obj)
      t = uicontrol(parent, 'style', 'popupmenu', 'Visible', 'off');
      if ~isempty(obj.listener_property)
        sc_addlistener(obj.viewer, obj.listener_property, @(~, ~) obj.listener_fcn, t);
      end
      obj.listener_fcn;
    end
    
    function listener_fcn(obj)
      if isempty(obj.listener_property)
        obj.uictrl.String = obj.get_string();
        obj.uictrl.Value = obj.get_value();
        obj.uictrl.Visible = 'on';
      elseif isempty(obj.viewer.(obj.listener_property))
        obj.uictrl.Visible = 'off';
      else
        obj.uictrl.String = obj.get_string();
        obj.uictrl.Value = obj.get_value();
        obj.uictrl.Visible = 'on';
      end
    end
    
    function callback(obj)
      obj.callback_fcn(obj.viewer, obj.uictrl.String, obj.uictrl.Value);
    end
    
  end
  
  methods (Access=private)
    function t = get_string(obj)
      if isfunction(obj.get_string_fcn)
        t = obj.get_string_fcn(obj.viewer);
        if isa(t, 'ScList') || isa(t, 'ScCellList')
          t = t.values('tag');
        elseif ~isnumeric(t) && ~ischar(t) && ~isempty(t)
          t = t.tag;
        end
      else
        t = obj.get_string_fcn;
      end
    end
    
    function t = get_value(obj)
      if isfunction(obj.get_value_fcn)
        t = obj.get_value_fcn(obj.viewer);
        if ~isnumeric(t)
          list = obj.get_string_fcn(obj.viewer);
          if ischar(t)
            t = find(equals(list, t));
          else
            t = find(equals(list, t.tag));
          end
        else
          t = obj.get_value;
        end
      end
    end
  end
end