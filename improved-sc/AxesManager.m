classdef AxesManager < handle
  
  properties (Dependent)
    trigger_axes
    signal1_axes
    signal2_axes
  end
  
  properties (SetAccess = 'private')
    m_trigger_axes
    m_signal1_axes
    m_signal2_axes
  end
  
  properties (Abstract)
    plot_window
  end
  
  methods (Abstract)
    varargout = update_axes_position(varargin)
  end
  
  methods
    
    function val = get.trigger_axes(obj)
      
      if isempty(obj.m_trigger_axes) || ~ishandle(obj.m_trigger_axes)
        
        obj.m_trigger_axes = axes('Parent', obj.plot_window);
        obj.update_axes_position();
        
      end
      
      val = obj.m_trigger_axes;
      
    end
    
    
    function val = get.signal1_axes(obj)
      
      if isempty(obj.m_signal1_axes) || ~ishandle(obj.m_signal1_axes)
        
        obj.m_signal1_axes = axes('Parent', obj.plot_window);
        obj.update_axes_position();
        
      end
      
      val = obj.m_signal1_axes;
      
    end
    
    
    function val = get.signal2_axes(obj)
      
      if isempty(obj.signal2)
        
        obj.m_signal2_axes = [];
        
        if ~isempty(obj.m_signal2_axes)
          
          cla(obj.m_signal2_axes);
          obj.m_signal2_axes = [];
          obj.update_axes_position();
          
        end
        
      elseif isempty(obj.m_signal2_axes) || ~ishandle(obj.m_signal1_axes)
        
        obj.m_signal2_axes = axes('Parent', obj.plot_window);
        obj.update_axes_position();
        
      end
      
      val = obj.m_signal2_axes;
      
    end
    
  end
end