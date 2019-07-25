function clickToDefineTemplate(obj)

currentPoint = obj.axes22.CurrentPoint;

if isempty(obj.tLeft)
  
  obj.tLeft          = currentPoint(1);
  obj.ephemeralPlots = add_to_list(obj.ephemeralPlots, ...
    line(obj.axes22, obj.tLeft*[1 1], ylim(obj.axes22)));
  
elseif isempty(obj.tRight)
  
  obj.tRight         = currentPoint(1);
  obj.ephemeralPlots = add_to_list(obj.ephemeralPlots, ...
    line(obj.axes22, obj.tLeft*[1 1], ylim(obj.axes22)));
  
  obj.ephemeralPlots = add_to_list(obj.ephemeralPlots, ...
    line(obj.axes22, obj.tRight*[1 1], ylim(obj.axes22)));
  
  triggerTime   = obj.getSelectedTriggerTimes();
  triggerTime   = triggerTime(1);
  [sweep, time] = sc_get_sweeps(obj.v, 0, triggerTime, ...
    obj.pretrigger, obj.posttrigger, obj.signal.dt);
  
  vShape = sweep(time >= obj.tLeft & time <= obj.tRight);
  names  = cellfun(@(x) x.tag, obj.signal.templates, 'UniformOutput', false);
  
  if strcmpi(obj.plotMode, 'defineConvTemplate')
    
    tag      = hamo.util.findUniqueName(names, 'convTemplate', 0);
    template = hamo.templates.ConvTemplate(vShape, tag);
    
  elseif strcmpi(obj.plotMode, 'defineAutoThreshold')
    
    tag      = hamo.util.findUniqueName(names, 'convTemplate', 0);
    template = hamo.templates.AutoThresholdTemplate(vShape, tag);
    
  elseif strcmpi(obj.plotMode, 'defineGenericTemplate')
    
    tag      = hamo.util.findUniqueName(names, 'genericTemplate', 0);
    template = hamo.templates.AutoThresholdTemplate(vShape, tag);
    
  elseif strcmpi(obj.plotMode, 'defineEmptyTemplate')
    
    tag      = hamo.util.findUniqueName(names, 'emptyTemplate', 0);
    template = hamo.templates.EmptyTemplate(vShape, tag, obj.tLeft, obj.tRight);
    
  else
    error('Illegal command: %s', obj.plotMode);
  end
  
  obj.addTemplate(template);
  obj.plotMode = 'plotSweep';
  obj.indxSelectedTemplate = length(obj.getEditableTemplates());
  obj.tLeft  = [];
  obj.tRight = [];
end

end
