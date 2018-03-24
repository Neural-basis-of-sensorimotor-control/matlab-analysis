classdef AxesManager < handle
  
  properties (Dependent)
    trigger_axes
    signal1_axes
    signal2_axes
  end
  
  properties (SetAccess = 'private', SetObservable)
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
    
    function clear_unused_axes(obj)
      
      if isempty(obj.signal2) || isa(obj.signal2, 'sc_tool.EmptyClass')
        
        delete(obj.m_signal2_axes);
        obj.m_signal2_axes = [];
        
      end
      
    end
    
  end
  
  methods
    % Getters and setters
    
    function val = get.trigger_axes(obj)
      
      if isempty(obj.m_trigger_axes) || ~ishandle(obj.m_trigger_axes)
        
        obj.m_trigger_axes = axes('Parent', obj.plot_window);
        linkaxes([obj.m_trigger_axes obj.signal1_axes], 'x');
      
      end
      
      val = obj.m_trigger_axes;
      
    end
    
    function val = get.signal1_axes(obj)
      
      if isempty(obj.m_signal1_axes) || ~ishandle(obj.m_signal1_axes)
        
        obj.m_signal1_axes = axes('Parent', obj.plot_window);
        
        z = zoom(obj.m_signal1_axes);
        set(z, 'ActionPostCallback', @(~, ~) obj.zoom_callback);
        
        p = pan(obj.plot_window);
        set(p, 'ActionPostCallback', @(~, ~) obj.zoom_callback);
      
      end
      
      val = obj.m_signal1_axes;
      
    end
    
    function val = get.signal2_axes(obj)
      
      if ~isempty(obj.signal2) && ~isa(obj.signal2, 'sc_tool.EmptyClass')
        
        if isempty(obj.m_signal2_axes) || ~ishandle(obj.m_signal2_axes)
          
          obj.m_signal2_axes = axes('Parent', obj.plot_window);
          linkaxes([obj.m_signal2_axes obj.signal1_axes], 'x');
          
        end
        
      end
      
      val = obj.m_signal2_axes;
      
    end
    
  end
end