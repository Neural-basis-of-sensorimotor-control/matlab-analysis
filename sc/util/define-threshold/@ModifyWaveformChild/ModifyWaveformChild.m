classdef ModifyWaveformChild < ModifyThreshold
  
  methods (Access = 'protected')
    varargout = create_ui_context_menu(varargin)
  end
  
  properties
    parent
  end
  
  methods
    
    function obj = ModifyWaveformChild(varargin)
      obj@ModifyThreshold(varargin{:});
    end
    
  end
  
end