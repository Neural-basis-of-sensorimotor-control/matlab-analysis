classdef Signal < ScSignal
  
  properties (SetAccess = 'private')
    templates = {};
  end
  
  methods
    function addTemplate(obj, template)
      obj.templates = add_to_list(obj.templates, template);
      template.parent = obj;
    end
    function rmTemplate(obj, template)
      obj.templates(cellfun(@(x) x==template, obj.templates)) = [];
    end
  end
end