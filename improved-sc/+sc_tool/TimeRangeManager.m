classdef TimeRangeManager < handle
  
  properties (Constant)
    max_time_range = 100
  end
  
  properties (Dependent)
    pretrigger
    posttrigger
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_pretrigger
    m_posttrigger
  end
  
  methods (Abstract)
    varargout = update_plots(varargin)
  end
  
  properties (Abstract)
    help_text
  end
  
  methods
    
    function obj = TimeRangeManager()
      
      obj.m_pretrigger  = sc_settings.get_pretrigger();
      obj.m_posttrigger = sc_settings.get_posttrigger();
      
    end
    
    
    function update_plot_if_within_range(obj)
      
      if obj.m_pretrigger < obj.m_posttrigger && ...
          obj.m_posttrigger - obj.m_pretrigger < obj.max_time_range
        
        obj.update_plots;
        
      else
        
        obj.help_text = sprintf('Time range must be > 0 and < %g.\nPlot aborted', obj.max_time_range);
        
      end
    end
    
    function delete(obj)
      
      sc_settings.set_pretrigger(obj.pretrigger);
      sc_settings.set_posttrigger(obj.posttrigger);
      
    end
    
  end
  
  methods
    %Getters and Setters
    
    function val = get.pretrigger(obj)
      val = obj.m_pretrigger;
    end
    
    function set.pretrigger(obj, val)
      
      obj.m_pretrigger = val;
      obj.update_plot_if_within_range();
      
    end
    
    function val = get.posttrigger(obj)
      val = obj.m_posttrigger;
    end
    
    function set.posttrigger(obj, val)
      
      obj.m_posttrigger = val;
      obj.update_plot_if_within_range();
      
    end
    
  end
  
end