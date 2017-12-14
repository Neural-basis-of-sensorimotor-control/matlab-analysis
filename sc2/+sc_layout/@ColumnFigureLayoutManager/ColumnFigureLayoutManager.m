classdef ColumnFigureLayoutManager < FigureLayoutManager & ...
    ColumnLayoutManager
  
  methods
    
    function obj = ColumnFigureLayoutManager(varargin)      
      obj@FigureLayoutManager(varargin{:});
    end
    
  end
end