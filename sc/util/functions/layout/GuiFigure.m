classdef GuiFigure < handle
  methods (Abstract)
    populate(obj,mgr)
  end
  properties
    panel
    ax
    window
  end
  properties (Constant)
    uppermargin = 15
    lowermargin = 30
    leftmargin = 15
    rightmargin = 15
  end
  methods
    function obj = GuiFigure()

    end
    function show(obj)
      obj.get_window();
      obj.panel = uipanel('Parent',obj.window);
      mgr = ScLayoutManager(obj.panel);
      obj.populate(mgr);
      mgr.trim;
      obj.ax = axes('Parent',obj.window);
      obj.resize_window();
    end
  end
  methods (Access = 'private')
    function close_request(obj)
      delete(obj.window);
    end
  end
  methods
    function window = get_window(obj)
      if isempty(obj.window) || ~ishandle(obj.window)
        obj.window = figure();
        set(obj.window,'SizeChangedFcn',@(~,~) obj.resize_window(),...
          'CloseRequestFcn',@(~,~) obj.close_request());
        end
        window = obj.window;
      end
      function resize_window(obj)
        width = getwidth(obj.window);
        y = getheight(obj.window)-getheight(obj.panel);
        sety(obj.panel,y);
        setx(obj.panel,0);
        setwidth(obj.panel,width);
        ax_height = y - obj.lowermargin - obj.uppermargin;
        setx(obj.ax,obj.leftmargin);
        sety(obj.ax,obj.lowermargin);
        setheight(obj.ax,ax_height);
        setwidth(obj.ax,width-obj.leftmargin-obj.rightmargin);
      end
    end
  end
