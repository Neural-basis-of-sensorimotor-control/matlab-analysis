classdef Signal < ScSignal & hamo.interfaces.Signal
  
  properties (SetAccess = 'private')
    templates = {};
  end
  
  methods
    
    function obj = Signal(varargin)
      obj@ScSignal(varargin{:});
    end
    
    function addTemplate(obj, template)
      obj.templates = add_to_list(obj.templates, template);
      template.parent = obj;
    end
    
    function rmTemplate(obj, template)
      obj.templates(cellfun(@(x) x==template, obj.templates)) = [];
    end
    
  end
end