classdef AmplitudeManager < handle
  
  properties (Dependent)
    amplitude
  end
  
  properties
    mouse_press = 1
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_amplitude
  end
  
  properties (Abstract)
    signal1_axes
    trigger_indx
    trigger_time
    has_unsaved_changes
  end
  
  methods
    
    function btn_dwn_amplitude(obj)
      
      if obj.mouse_press > 0
        
        p  = get(obj.signal1_axes, 'CurrentPoint');
        t0 = p(1,1);
        v0 = p(1,2);
        
        if t0<0
          
          obj.set_sweep(obj.trigger_indx + 1);
          
        else
          
          stimtime = obj.trigger_time(1);
          obj.amplitude.add_data(stimtime, 2*obj.mouse_press - [1 0], [t0 v0]);
          obj.has_unsaved_changes = true;
          
          if obj.mouse_press == 1
            obj.set_mouse_press(2);
          else
            obj.set_sweep(obj.trigger_indx + 1);
          end
          
        end
      end
      
    end
    
    
    function set_sweep(obj, indx)
      
      obj.trigger_indx = mod(indx-1, numel(obj.all_trigger_times)) + 1;
      
      if ~isempty(obj.amplitude) && ~isempty(indx)
        
        triggertime = obj.trigger_time(1);
        val         = obj.amplitude.get_data(triggertime,[1 3]);
        mousepress  = find(isnan(val), 1);
        
        if isempty(mousepress)
          obj.set_mouse_press(0);
        else
          obj.set_mouse_press(mousepress);
        end
        
      end
    end
    
    function set_mouse_press(obj, val)
      
      obj.mouse_press = val;
      
      if obj.mouse_press ==1 || obj.mouse_press == 2
        obj.help_text = sprintf('Awaiting mouse press #%i',obj.mouse_press);
      else
        obj.help_text = 'Amplitude is set for this sweep';
      end
      
      obj.update_plots();
      
    end
    
  end
  
  methods
    %Getters and setters
    
    function val = get.amplitude(obj)
      val = obj.m_amplitude;
    end
    
    function set.amplitude(obj, val)
      obj.m_amplitude = val;
    end
    
  end
end