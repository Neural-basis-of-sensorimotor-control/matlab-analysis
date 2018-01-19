classdef ScViewerComponent < sc_viewer.ScGuiComponent
  
  properties
    viewer
  end
  
  methods
    
    function obj = ScViewerComponent(ui_object, viewer)
      
      obj@sc_viewer.ScGuiComponent(ui_object);
      obj.viewer = viewer;
    end
    
  end
  
end