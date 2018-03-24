classdef ZoomManager < handle
  
  properties (Dependent)
    zoom_on
    pan_on
  end
  
  properties
    xlimits
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_zoom_on
    m_pan_on
  end
  
  properties (Abstract)
    signal1_axes
    help_text
    plot_mode
  end
  
  methods
    
    function obj = ZoomManager()
      
      obj.m_zoom_on = false;
      obj.m_pan_on  = false;
      
    end
    
    
    function zoom_callback(obj)
      
      obj.xlimits = xlim(obj.signal1_axes);
    end
    
  end
  
  methods
    %Getters & setters
    
    function val = get.zoom_on(obj)
      val = obj.m_zoom_on;
    end
    
    function set.zoom_on(obj, val)
      
      obj.m_zoom_on = val;
      
      if val
        
        obj.pan_on = false;
        zoom(obj.signal1_axes, 'on');
        obj.help_text = 'Zoom on';
        
      else
        
        zoom(obj.signal1_axes, 'off');
        obj.help_text = char(obj.plot_mode);
        
      end
      
    end
    
    function val = get.pan_on(obj)
      val = obj.m_pan_on;
    end
    
    function set.pan_on(obj, val)
      
      obj.m_pan_on = val;
      
      if val
        
        obj.zoom_on = false;
        pan(obj.signal1_axes, 'on');
        obj.help_text = 'Pan on';
        
      else
        
        pan(obj.signal1_axes, 'off');
        obj.help_text = char(obj.plot_mode);
        
      end
      
    end
    
  end
  
end