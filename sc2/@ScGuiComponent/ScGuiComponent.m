classdef ScGuiComponent < handle
  
  properties
    viewer
  end
  
  methods
    
    function obj = ScGuiComponent(viewer)
      obj.viewer = viewer;
    end
    
  end
  
end