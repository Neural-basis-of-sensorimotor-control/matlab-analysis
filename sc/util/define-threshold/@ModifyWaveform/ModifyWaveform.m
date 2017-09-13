classdef ModifyWaveform < handle
  
  methods
    
    varargout = sc_save(varargin)
    varargout = init_plot(varargin)
    varargout = add_threshold(varargin)
    varargout = reset_axes(varargin)
    
  end
  
  methods (Access = 'private')
    
    varargout = btn_dwn_define_starting_point(varargin)
    
  end
  
  properties
    
    waveform
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
      
      if isneuron(signal)
        signal = sc_load_signal(signal);
      end
      
      if ischar(waveform)
        
        waveform_tag = waveform; 
        waveform     = signal.waveforms.get('tag', waveform_tag);
        
        if isempty(waveform)
          
          waveform = ScWaveform(signal, waveform_tag, []);
          signal.waveforms.add(waveform);
          
        end
        
      end
      
      obj.waveform = waveform;
      
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