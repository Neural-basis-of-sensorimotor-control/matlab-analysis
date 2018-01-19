classdef FigureLayoutManager < sc_layout.LayoutManager
  
  methods
    
    function obj = FigureLayoutManager(varargin)
      
      obj@sc_layout.LayoutManager(varargin{:});
      set(obj.parent, 'SizeChangedFcn', @(~, ~) obj.trim());
      
    end
    
  end
  
end