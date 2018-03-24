classdef AxesHeightManager < sc_tool.AxesManager
  
  properties (Dependent)
    axes_height
    nbr_of_axes
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_axes_height
  end
  
  properties (Constant)
    upper_margin  = 10
    middle_margin = 40
    lower_margin  = 40
    left_margin = 120
    right_margin = 40
  end
  
  methods
    
    function obj = AxesHeightManager()
      obj.axes_height = sc_settings.get_axes_height();
    end
    
    
    function update_axes_position(obj)
      
      if isempty(obj.plot_window) || ~ishandle(obj.plot_window)
        return
      end
      
      tile_height = obj.axes_height;
      
      x = obj.left_margin;
      y = getheight(obj.plot_window) - obj.upper_margin - tile_height(1);
      tile_width = getwidth(obj.plot_window) - obj.left_margin - ...
        obj.right_margin;
      
      setx(obj.trigger_axes, x);
      sety(obj.trigger_axes, y);
      setwidth(obj.trigger_axes, tile_width);
      setheight(obj.trigger_axes, tile_height(1));
      
      y = y - tile_height(2) - obj.middle_margin;
      setx(obj.signal1_axes, x);
      sety(obj.signal1_axes, y);
      setwidth(obj.signal1_axes, tile_width);
      setheight(obj.signal1_axes, tile_height(2));
      
      if ~isempty(obj.signal2_axes)
        
        y = y - tile_height(3) - obj.middle_margin;
        setx(obj.signal2_axes, x);
        sety(obj.signal2_axes, y);
        setwidth(obj.signal2_axes, tile_width);
        setheight(obj.signal2_axes, tile_height(3));
        
      end
      
    end
    
    
    function val = get_auto_height(obj)
      
      figure_height = getheight(obj.plot_window);
      tile_height   = (figure_height - obj.upper_margin - obj.lower_margin - ...
        (obj.nbr_of_axes - 1)*obj.middle_margin)/obj.nbr_of_axes;
      val = tile_height * ones(obj.nbr_of_axes, 1);
      
    end
    
    
    function val = get.nbr_of_axes(obj)
      
      if isempty(obj.signal2_axes) || isa(obj.signal2_axes, 'sc_tool.EmptyClass')
        val = 2;
      else
        val = 3;
      end
      
    end
    
    
    function delete(obj)
      
      sc_settings.set_axes_height(obj.m_axes_height);
      
    end
    
  end
  
  methods
    % Getters and setters
    
    function val = get.axes_height(obj)
      
      if ischar(obj.m_axes_height) || ...
          length(obj.m_axes_height) < obj.nbr_of_axes
        
        val = obj.get_auto_height();
      
      else
        
        val = obj.m_axes_height;
      
      end
      
    end
    
    function set.axes_height(obj, val)
      
      if ischar(val)
        
        if strcmpi(val, 'auto')
          obj.m_axes_height = val;
        else
          obj.m_axes_height = str2num(val);
        end
        
      else
        
        obj.m_axes_height = val;
        
      end
      
      obj.update_axes_position();
      
    end
    
  end
end