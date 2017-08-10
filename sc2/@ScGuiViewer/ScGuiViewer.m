classdef ScGuiViewer < ScViewer
  
  properties
    
    button_window
    
  end
  
  methods
    
    function obj = ScGuiViewer(h_figure) 
      obj.button_window = h_figure;
    end
    
  end
  
end