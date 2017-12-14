classdef LayoutManager < handle
  
  methods (Abstract)
    update_position(obj)
  end
  
  properties
    
    parent
    x0
    y0
    x
    y
    fixed_width
    fixed_height
    fill_right   = false
    fill_down    = false
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
    
    
    function add(obj, tile)
      
      set(tile, 'Parent', obj.parent);
      
      obj.tiles = add_to_list(obj.tiles, tile);
      
      if ~isempty(obj.fixed_width)
        setwidth(tile, obj.fixed_width);
      end
      
      if ~isempty(obj.fixed_height)
        setheight(tile, obj.fixed_height);
      end
      
      obj.set_position(tile);
      
    end
    
    
    function layout(obj)
      
      obj.reset_position();
      
      xvalues   = cell2mat(get_values(obj.tiles, @getx));
      
      unique_x  = unique(xvalues);
      
      for i=1:length(unique_x)
        
        tmp_x       = unique_x(i);
        tmp_tiles   = obj.tiles(xvalues == tmp_x);
        
        [~, ind_y]  = sort(cell2mat(get_values(tmp_tiles, @gety)));
        ind_y       = ind_y(length(ind_y):-1:1); 
        tmp_tiles   = tmp_tiles(ind_y);
        
        obj.x       = tmp_x;
        obj.y       = getheight(obj.parent);
        
        if obj.fill_right && i == length(unique_x)
          
          tmp_width = getwidth(obj.parent) - tmp_x;
          
          if tmp_width > 0
            
            for j=1:length(tmp_tiles)
              setwidth(tmp_tiles(j), tmp_width);
            end
            
          end
          
        end
        
        for j=1:length(tmp_tiles)
          
          if obj.fill_down && j == length(tmp_tiles)
            
            tmp_height = obj.y;
            
            if tmp_height > 0
              setheight(tmp_tiles(j), tmp_height);
            end
            
          end
          
          obj.set_position(tmp_tiles(j));
          
        end
        
      end
      
    end
    
  end
  
  methods (Access = 'protected')
    
    function set_position(obj, tile)
      
      obj.update_position(tile);
      
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