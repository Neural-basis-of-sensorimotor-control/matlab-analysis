classdef ColumnLayoutManager < LayoutManager
  
  methods
    
    function obj = ColumnLayoutManager(varargin)
      
      obj@LayoutManager(varargin{:});
      
    end
    
    
    function update_position(obj, tile)
      
      height = getheight(tile);
      obj.y  = obj.y - height;
      
    end
    
    
    function increment_column(obj)
      
      xvalues = cell2mat(get_values(obj.tiles, @getx));
      widths  = cell2mat(get_values(obj.tiles, @getwidth));
      
      obj.x = max(xvalues + widths);
      obj.y = getheight(obj.h_figure);
      
    end
    
  end
  
end
