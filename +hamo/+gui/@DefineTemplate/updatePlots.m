function updatePlots(obj)

triggerTime   = obj.getSelectedTriggerTimes();
[sweep, time] = sc_get_sweeps(obj.v, 0, triggerTime, obj.pretrigger, ...
  obj.posttrigger, obj.signal.dt);
rawSweep      = sc_get_sweeps(obj.vRaw, 0, triggerTime, obj.pretrigger, ...
  obj.posttrigger, obj.signal.dt);

cla(obj.axes12)
hold(obj.axes12, 'on')
grid(obj.axes12, 'on')
triggableTemplates = obj.getTriggableTemplates();

for i=1:length(triggableTemplates)
  template = triggableTemplates{i};
  template.plotTriggerTimes(obj.axes12, i, triggerTime, time(1), time(end));
end

ylim(obj.axes12, [0 length(obj.getTriggableTemplates())+1]);
obj.axes12.YTick = 1:length(obj.getTriggableTemplates());
obj.axes12.YTickLabel = cellfun(@(x) getFormattedTag(x, '*'), ...
  obj.getTriggableTemplates(), 'UniformOutput', false);

cla(obj.axes22);
grid(obj.axes22, 'on')
hold(obj.axes22, 'on')

obj.plotSweep(sweep, time, 'filtered');
obj.plotSweep(rawSweep, time, 'raw');

if ~isempty(rawSweep)
  add_legend(obj.axes22);
end


if strcmpi(obj.plotMode,  'defineConvTemplate')    || ...
    strcmpi(obj.plotMode, 'defineAutoThreshold')   || ...
    strcmpi(obj.plotMode, 'defineGenericTemplate')
  
  obj.axes22.ButtonDownFcn = @(~, ~) clickToDefineTemplate(obj);
  
else
  
  obj.axes22.ButtonDownFcn = @(~, ~) clickToDrawTemplate(obj);
  cla(obj.axes31)
  template = obj.getSelectedTemplate();
  
  if ~isempty(template)
    
    template.plotShape(obj.axes31, 0, 0);
    grid(obj.axes31, 'on')
    
    cla(obj.axes32)
    grid(obj.axes32, 'on')
    hold(obj.axes32, 'on')
    template.plotSweep(obj.axes32, time, sweep, triggerTime);
    title(obj.axes32, sprintf('template #%d', obj.indxSelectedTemplate));
  end
end

linkaxes([obj.axes12 obj.axes22 obj.axes32], 'x');
xlim(obj.axes12, [time(1) time(end)])



end