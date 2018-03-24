classdef GuiManager < sc_tool.GuiWrapper & CloseRequestFigure
  
  properties
    button_window
  end
    
  methods (Static)
    varargout = get_panels(varargin)
    varargout = create_ui_object(varargin)
  end
  
  methods
    
    function obj = GuiManager()
      
      obj.button_window = figure('ToolBar', 'none', 'MenuBar', 'none', ...
        'Color', 'k', ...
        'CloseRequestFcn', @(~, ~) obj.close_request(), ...
        'Tag', SequenceViewer.figure_tag, ...
        'DeleteFcn', @(~, ~) obj.save_button_window_pos());
      
    end
    
  end
  
end