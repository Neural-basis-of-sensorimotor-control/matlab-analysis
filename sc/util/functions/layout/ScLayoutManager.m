classdef ScLayoutManager < handle
  
  properties
    leftindent = 0
    rowheight = 20
  end
  
  properties (SetAccess = 'private')
    
    panel
    
    xpos
    ypos
    
    panelheight
    panelwidth
    
  end
  
  methods
    
    function obj = ScLayoutManager(panel, varargin)
      
      obj.panel = panel;
      set(panel,'unit','pixel');
      position = get(panel,'position');
      obj.panelwidth = position(3);
      obj.panelheight = position(4);
      
      for i=1:2:numel(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
      obj.xpos = obj.leftindent;
      obj.ypos = obj.panelheight;
      
    end
    
    function dummy = add_dummy_button(obj,string,width)
      
      dummy = obj.add(uicontrol('style','pushbutton','string',string,...
        'callback',@(~,~) msgbox('This feature is not yet implemented'...
        )),width);
      
    end
    
    
    function tile = add(obj, tile, width)
      
      if nargin>2
        setwidth(tile,width);
      end
      
      set(tile,'parent',obj.panel);
      setheight(tile,obj.rowheight);
      setx(tile,obj.xpos);
      sety(tile,obj.ypos);
      obj.xpos = obj.xpos + getwidth(tile);
      
    end
    
    
    function tile = addsc(obj,varargin)
      
      args = varargin(1:end-1);
      width = varargin{end};
      tile = sc_ctrl(args{:});
      obj.add(tile,width);
      
    end
    
    function tile = addobject(obj, tile, width)
      
      obj.newline(getheight(tile));
      
      if nargin<3
        obj.add(tile);
      else
        obj.add(tile,width);
      end
      
    end
    
    
    function newline(obj, rowheight)
      
      obj.xpos = obj.leftindent;
      
      if nargin==1
        
        obj.ypos = obj.ypos - obj.rowheight;
        
      else
        
        obj.ypos = obj.ypos - rowheight;
        obj.rowheight = rowheight;
        
      end
      
    end
    
    
    function trim(obj)
      
      set(obj.panel,'unit','pixel');
      pos = get(obj.panel,'position');
      
      if strcmp(get(obj.panel,'Type'),'figure')
        
        panelheightdiff = getheight(obj.panel) - obj.panelheight;
        tiles = get(obj.panel,'children');
        
        for i=1:numel(tiles)
          
          set(tiles(i),'unit','pixel');
          pos = get(tiles(i),'position');
          pos(2) = pos(2)+panelheightdiff;
          set(tiles(i),'position',pos);
          
        end
        
        obj.panelheight = getheight(obj.panel);
        
      else
        
        total_tile_height = obj.panelheight - obj.ypos;
        obj.panelheight = total_tile_height;
        ytop = pos(2)+pos(4);
        ybottom = ytop - total_tile_height;
        pos(2) = ybottom; pos(4) = total_tile_height;
        set(obj.panel,'position',pos);
        tiles = get(obj.panel,'children');
        
        for i=1:numel(tiles)
          
          set(tiles(i),'unit','pixel');
          pos = get(tiles(i),'position');
          pos(2) = pos(2)-obj.ypos;
          set(tiles(i),'position',pos);
          
        end
        
      end
    end
  end
end
