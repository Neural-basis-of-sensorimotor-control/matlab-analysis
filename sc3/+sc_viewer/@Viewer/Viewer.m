classdef Viewer < handle
  
  methods (Static)
    varargout = get_panels(varargout)
  end
  
  properties
    button_window
    plot_window
  end
  
  properties (SetAccess = 'protected', SetObservable)
    
    experiment
    file
    sequence
    signal1
    signal2
    waveform
    amplitude
    
    trigger_parent
    trigger_tag
    
  end
  
  properties (SetAccess = 'protected')
    
    triggeraxes
    channelaxes1
    channelaxes2
    
  end
  
end