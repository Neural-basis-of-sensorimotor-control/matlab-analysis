classdef GuiManager < sc_tool.GuiWrapper
  
  properties
    button_window
  end
  
  methods (Static)
    varargout = get_panels(varargin)
    varargout = create_ui_object(varargin)
  end
  
  methods
    
    function obj = GuiManager()
      
      obj.button_window = figure('ToolBar', 'none', 'Color', 'k');
      
    end
    
  end
end