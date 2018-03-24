classdef FigureLayoutManager < sc_layout.LayoutManager
  
  methods
    
    function obj = FigureLayoutManager(parent, varargin)
      
      obj@sc_layout.LayoutManager(parent, 'upper_margin', 0, varargin{:});
      set(obj.parent, 'SizeChangedFcn', @(~, ~) obj.trim());
      
    end
    
  end
  
end