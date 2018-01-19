classdef ScPlotViewer < handle
  
  properties
    plot_window
  end
  
  properties (SetAccess = protected, SetObservable)
    
    plot_mode
    plot_raw_data
    plot_waveforms
    v_equals_zero_for_t
  
  end
  
  properties (Constant)
    figure_tag = 'sc-viewer-figure-tag'
  end
  
end