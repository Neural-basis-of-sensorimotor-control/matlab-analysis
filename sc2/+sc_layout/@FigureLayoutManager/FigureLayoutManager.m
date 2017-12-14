classdef FigureLayoutManager < LayoutManager
  
  methods
    
    function obj = FigureLayoutManager(varargin)
      
      obj@LayoutManager(varargin{:});
      set(obj.parent, 'SizeChangedFcn', @(~, ~) obj.layout());
    
    end
    
  end
  
end