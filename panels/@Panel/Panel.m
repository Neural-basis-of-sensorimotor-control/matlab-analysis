classdef Panel < GuiComponent   
  methods (Abstract)
    %Populate gui_components property from inheriting class
    setup_components(obj);
  end
  properties (SetObservable)
    %to invoke enabled_listener function
    enabled = false
  end
  
  properties
    %ScCellList of PanelComponent objects
    gui_components
  end
  
  properties (Dependent)
    height
  end
  
  methods
    %overriding classes have to call obj.layout after creation of
    %constructor
    function obj = Panel(gui, panel)
      obj@GuiComponent(gui,panel);
      addlistener(obj,'enabled','PostSet',@(~,~) obj.enabled_listener);
    end
    
    %Populate PanelComponents objects
    function layout(obj)
      obj.gui_components = ScCellList();
      obj.setup_components();
      mgr = ScLayoutManager(obj.uihandle);
      mgr.newline(obj.upper_margin());
      for k=1:obj.gui_components.n
        obj.gui_components.get(k).populate(mgr);
      end
      mgr.newline(2);
      mgr.trim();
    end
    
    %Update values in text boxes, popupmenus, etc
    function initialize_panel(obj)
      for k=1:obj.gui_components.n
        obj.gui_components.get(k).initialize();
      end
    end
    
    %Reload values and update enabled property
    function update_panel(obj)
      updated = true;
      for k=1:obj.gui_components.n
        updated = updated & obj.gui_components.get(k).update();
      end
      obj.enabled = updated;
    end
    
    %Make panel inaccessible to user
    %   do_lock:    true    -> lock
    %               false   -> unlock
    function lock_panel(obj,do_lock)
      if do_lock
        enablestr = 'off';
      else
        enablestr = 'on';
      end
      children = get(obj.uihandle,'children');
      set(children,'Enable',enablestr);
    end
    
    %Height of graphical object
    function height = get.height(obj)
      height = getheight(obj.uihandle);
    end
  end
  
  
  methods (Static)
    %Margin between top of uipanel and first PanelComponent object 
    function val = upper_margin()
      val = 15;
    end
  end
  
  methods %(Access = 'protected')
    %If enabled is set to false, the subsequent panels will be hidden
    %If previous panel is disabled, this panel will be hidden, unless
    %it is the first panel
    function enabled_listener(obj)
      index = obj.gui.panels.indexof(obj);
      if index<2 || obj.gui.panels.get(index-1).enabled
        previous_panel_enabled = true;
      else
        previous_panel_enabled = false;
      end
      if obj.enabled || previous_panel_enabled
        set(obj.uihandle,'Visible','on');
      else
        set(obj.uihandle,'Visible','off');
      end
      if index > -1 && index < obj.gui.panels.n
        if obj.enabled 
          set(obj.gui.panels.get(index+1),'Visible','on');
        else
          set(obj.gui.panels.get(index+1),'Visible','off');
        end
      end
    end
  end
end
