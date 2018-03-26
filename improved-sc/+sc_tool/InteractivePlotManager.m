classdef InteractivePlotManager < handle
  
  properties (Dependent)
    interactive_mode
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_interactive_mode
  end
  
  methods
    
    function val = get.interactive_mode(obj)
     
      if isempty(obj.m_interactive_mode)
        val = false;
      else
        val = obj.m_interactive_mode;
      end
      
    end
    
    function set.interactive_mode(obj, val)
      
      if isempty(val)
        val = false;
      end
      
      if val && ~obj.interactive_mode
        
        obj.modify_waveform = ModifyWaveform(obj.signal1_axes, obj.signal1, ...
          obj.waveform);
        
      elseif ~val && obj.interactive_mode
        
        if obj.modify_waveform.has_unsaved_changes
          
          answ = questdlg('There are unsaved waveform changes. Save?');
          
          if isempty(answ) || strcmp(answ, 'Cancel')
            return
          elseif strcmp('answ', 'Yes')
            obj.modify_waveform.sc_save(false);
          end
          
        end
              
        obj.modify_waveform = [];
        
      end
      
      if val
        obj.m_interactive_mode = val;
      else
        obj.m_interactive_mode = [];
      end
      
      obj.update_plots();
      
    end
    
  end
  
end