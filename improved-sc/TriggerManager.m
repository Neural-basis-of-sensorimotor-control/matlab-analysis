classdef TriggerManager < WaveformManager & AmplitudeManager
  
  properties (Dependent)
    trigger_parent
    trigger
    trigger_indx
    trigger_time
    all_trigger_times
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_trigger_parent
    m_trigger
    m_trigger_indx
    m_trigger_time
  end
  
  properties (Abstract)
    sequence
  end
  
  methods (Abstract)
    varargout = update_plots(varargin)
  end
  
  methods
    
    function val = get.trigger_parent(obj)
      val = obj.m_trigger_parent;
    end
    
    function set.trigger_parent(obj, val)
      
      if isa(val, 'EmptyClass')
        
        obj.m_trigger_parent = val.source;
        
        if isempty(val.source)

          obj.trigger = get_set_val(obj.signal1.amplitudes.list, ...
            obj.amplitude, 1);
          obj.plot_mode = PlotModeEnum.plot_amplitude;

        end
        
      else
           
        obj.m_trigger_parent = val;
        obj.trigger = get_set_val(val.triggers.list, obj.trigger, 1);
      
      end
      
    end
    
    function val = get.trigger(obj)
      val = obj.m_trigger;
    end
    
    function set.trigger(obj, val)
      
      obj.m_trigger = val;
      
      if isempty(obj.m_trigger)
        obj.trigger_indx = [];
      else
        obj.trigger_indx = 1;
      end
      
    end
    
    
    function val = get.trigger_indx(obj)
      val = obj.m_trigger_indx;
    end
    
    
    function set.trigger_indx(obj, val)
      
      obj.m_trigger_indx = val;
      
      if isempty(obj.trigger_indx)
        obj.trigger_time = obj.sequence.tmin;
      else
        obj.trigger_time = obj.all_trigger_times(obj.trigger_indx);
      end
      
    end
    
    function val = get.trigger_time(obj)
      val = obj.m_trigger_time;
    end
    
    function set.trigger_time(obj, val)
      
      obj.m_trigger_time = val;
      obj.update_plots();
      
    end
    
    
    function val = get.all_trigger_times(obj)
      
      if isempty(obj.trigger)
        val = obj.m_trigger_time;
      else
        val = obj.trigger.gettimes(obj.sequence.tmin, obj.sequence.tmax);
      end
      
    end
    
  end
  
end