classdef LayoutManager < handle
  
  properties
    
    parent
    upper_margin = 15
    x0
    y0
    x
    y
    tiles
    
  end
  
  methods
    
    function obj = LayoutManager(parent, varargin)
      
      obj.parent  = parent;
      
      obj.x0 = 0;
      obj.y0 = getheight(obj.parent);
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
      obj.reset_position();
      
    end
    
    
    function tile = add(obj, tile, width)
      
      set(tile, 'Parent', obj.parent);
      
      obj.tiles = add_to_list(obj.tiles, tile);
      
      setwidth(tile, width);
      
      setx(tile, obj.x);
      sety(tile, obj.y);
      
      obj.x = obj.x + getwidth(tile);
      
    end
    
    function newline(obj)
      
      obj.x = obj.x0;
      obj.y = obj.y - getheight(obj.tiles(end));
    
    end
    
    
    function trim(obj)
      
      all_y = arrayfun(@gety, obj.tiles);
      same_y_as_previous_tile = [false all_y(1:end-1) == all_y(2:end)];
      
      if ~strcmp(get(obj.parent, 'Type'), 'figure')
        setheight(obj.parent, sum(arrayfun(@getheight, obj.tiles(~same_y_as_previous_tile))) + ...
          obj.upper_margin);
      end
      
      x_column = obj.x0;
      y_row    = getheight(obj.parent) - obj.upper_margin;
      
      x_ = x_column;
      y_ = y_row;
      
      for i=1:length(obj.tiles)
        
        if same_y_as_previous_tile(i)
          
          x_ = x_ + getwidth(obj.tiles(i-1));
        
        else
          
          x_ = x_column;
          y_row = y_row - getheight(obj.tiles(i));
          y_ = y_row;
        
        end
        
        setx(obj.tiles(i), x_);
        sety(obj.tiles(i), y_);
        
        if strcmp(get(obj.parent, 'Type'), 'figure') && ...
            i < length(obj.tiles) && ...
            y_row - getheight(obj.tiles(i)) < 0
          
          x_column = x_column + getwidth(obj.tiles(i));
          y_row = getheight(obj.parent);
          
        end
        
      end

    end
    
  end
  
  methods (Access = 'protected')
    
    function set_position(obj, tile)
      
      height = getheight(tile);
      obj.y  = obj.y - height;
      
      setx(tile, obj.x);
      sety(tile, obj.y);
      
    end
    
  end
  
  methods (Access = 'private')
    
    function reset_position(obj)
      
      obj.x = obj.x0;
      obj.y = obj.y0;
      
    end
    
  end
  
end