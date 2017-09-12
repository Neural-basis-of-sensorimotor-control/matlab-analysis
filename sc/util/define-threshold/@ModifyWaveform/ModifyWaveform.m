classdef ModifyWaveform < handle
  
  methods (Access = 'public')
    
    varargout = sc_save(varargin)
    varargout = init_plot(varargin)
    
  end
  
  methods (Access = 'private')
    
    varargout = btn_dwn_define_starting_point(varargin)
    
  end
  
  properties
    
    thresholds
    h_axes
    
  end
  
  properties (Dependent, SetAccess = 'private')
    
    has_unsaved_changes
    
  end
  
  methods
    
    function obj = ModifyWaveform(h_axes, signal, waveform)
      
      obj.thresholds = [];
      obj.h_axes     = h_axes;
      
      colors = varycolor(length(waveform.list));
      
      for i=1:length(waveform.list)
        
        mthr           = ModifyThreshold(h_axes, signal, waveform.list(i));
        mthr.color     = colors(i, :);
        obj.thresholds = add_to_list(obj.thresholds, mthr);
        
      end
      
    end
    
    
    function val = get.has_unsaved_changes(obj)
      
      if isempty(obj.thresholds)
        val = false;
      else
        val = any(cell2mat({obj.thresholds.has_unsaved_changes}));
      end
      
    end
    
  end
  
end