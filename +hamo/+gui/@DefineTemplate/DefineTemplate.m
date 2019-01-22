classdef DefineTemplate < handle
  
  properties
    tLeft
    tRight
    plotMode = 'plotSweep'
    axes12
    axes22
    axes32
    axes31
    dt = 1e-5
    ephemeralPlots
    v
  end
  
  properties (Dependent)
    signal
    indxSelectedTemplate
    trigger
    pretrigger
    posttrigger
    triggerTimes
    triggerIndx
    rectificationPoint
  end
  
  properties (SetAccess = 'private')
    m_indxSelectedTemplate = 1
    m_signal
    m_trigger
    m_pretrigger   = -5e-3
    m_posttrigger  = 3e-2
    m_triggerTimes = 1
    m_triggerIndx  = 1
    m_rectificationPoint = []
  end
  
  methods
    
    function obj = DefineTemplate(signal, fig)
      obj.signal = signal;
      clf(fig);
      obj.axes12 = subplot(3, 5, 2:5);
      obj.axes22 = subplot(3, 5, 5+(2:5));
      obj.axes32 = subplot(3, 5, 10+(2:5));
      obj.axes31 = subplot(3, 5, 11);
    end
    
    function val = get.rectificationPoint(obj)
      val = obj.m_rectificationPoint;
    end
    
    function set.rectificationPoint(obj, val)
      obj.m_rectificationPoint = val;
    end
    
    function val = get.trigger(obj)
      val = obj.m_trigger;
    end
    
    function set.trigger(obj, val)
      if isnumeric(val)
        obj.m_trigger    = [];
        obj.triggerTimes = val;
      else
        obj.m_trigger    = val;
        obj.triggerTimes = val.getTriggerTimes();
      end
    end
    
    function val = get.pretrigger(obj)
      val = obj.m_pretrigger;
    end
    
    function set.pretrigger(obj, val)
      obj.m_pretrigger = val;
    end
    
    function val = get.posttrigger(obj)
      val = obj.m_posttrigger;
    end
    
    function set.posttrigger(obj, val)
      obj.m_posttrigger = val;
    end
    
    function val = get.triggerTimes(obj)
      val = obj.m_triggerTimes;
    end
    
    function set.triggerTimes(obj, val)
      obj.m_trigger      = [];
      obj.m_triggerTimes = val;
      obj.triggerIndx    = 1;
    end
    
    function val = get.triggerIndx(obj)
      val = obj.m_triggerIndx;
    end
    
    function set.triggerIndx(obj, val)
      val = unique(mod(val-1, length(obj.triggerTimes))+1);
      obj.m_triggerIndx = val;
    end
    
    function val = get.indxSelectedTemplate(obj)
      val = min(length(obj.getEditableTemplates()), obj.m_indxSelectedTemplate);
    end
    
    function set.indxSelectedTemplate(obj, val)
      val = min(length(obj.getEditableTemplates()), val);
      obj.m_indxSelectedTemplate = val;
      obj.plotSweep;
    end
    
    function val = get.signal(obj)
      val = obj.m_signal;
    end
    
    function set.signal(obj, val)
      obj.m_signal = val;
      if isempty(val)
        obj.v = [];
      else
        obj.v = obj.signal.get_v(true, true, true, true);
        a = .001;
        obj.v = filter([1-a a-1], [1 a-1], obj.v);
      end
    end
    
    function val = getTriggerTime(obj)
      if isempty(obj.triggerTimes)
        val = [];
      else
        val = obj.triggerTimes(obj.triggerIndx);
      end
    end
    
    function plotSweep(obj)
      
      triggerTime = obj.getTriggerTime();
      [sweep, time] = sc_get_sweeps(obj.v, 0, triggerTime, ...
        obj.pretrigger, obj.posttrigger, obj.dt);
      
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
      
      if isempty(obj.rectificationPoint)
        plot(obj.axes22, time, sweep, 'HitTest', 'off')
      else
        for i=1:size(sweep, 2)
          [~, tmp] = min(abs(time - obj.rectificationPoint));
          plot(obj.axes22, time, sweep(:, i) - sweep(tmp, i), 'HitTest', 'off');
        end
      end
      if strcmpi(obj.plotMode, 'defineConvTemplate') ||...
          strcmpi(obj.plotMode, 'defineAutoThreshold')
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
    
    function addConvTemplate(obj)
      obj.plotMode = 'defineConvTemplate';
      obj.plotSweep();
    end
    
    function addAutoThresholdTemplate(obj)
      obj.plotMode = 'defineAutoThreshold';
      obj.plotSweep();
    end
    
    function clickToDefineTemplate(obj)
      currentPoint = obj.axes22.CurrentPoint;
      if isempty(obj.tLeft)
        obj.tLeft = currentPoint(1);
      elseif isempty(obj.tRight)
        obj.tRight = currentPoint(1);
        triggerTime = obj.getTriggerTime();
        triggerTime = triggerTime(1);
        [sweep, time] = sc_get_sweeps(obj.v, 0, triggerTime, ...
          obj.pretrigger, obj.posttrigger, obj.dt);
        vShape = sweep(time >= obj.tLeft & time <= obj.tRight);
        names = cellfun(@(x) x.tag, obj.signal.templates, 'UniformOutput', false);
        if strcmpi(obj.plotMode, 'defineConvTemplate')
          tag = hamo.util.findUniqueName(names, 'convTemplate', 0);
          template = hamo.templates.ConvTemplate(vShape, tag);
        elseif strcmpi(obj.plotMode, 'defineAutoThreshold')
          tag = hamo.util.findUniqueName(names, 'convTemplate', 0);
          template = hamo.templates.AutoThresholdTemplate(vShape, tag);
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
    
    function clickToDrawTemplate(obj)
      for i=1:length(obj.ephemeralPlots)
        if ishandle(obj.ephemeralPlots(i))
          delete(obj.ephemeralPlots(i));
        end
      end
      obj.ephemeralPlots = [];
      
      currentPoint = obj.axes22.CurrentPoint;
      x = currentPoint(1, 1);
      y = currentPoint(1, 2);
      template = obj.getSelectedTemplate();
      obj.ephemeralPlots = template.plotShape(obj.axes22, x, y);
    end
    
    function updateTemplates(obj)
      triggableTemplates = obj.getTriggableTemplates();
      for i=1:length(triggableTemplates)
        template = triggableTemplates{i};
        if ~template.isUpdated
          template.triggerIndx = ...
            template.match_v(obj.v);
          template.isUpdated = true;
        end
      end
    end
    
    function val = getEditableTemplates(obj)
      if isempty(obj.signal)
        val = {};
      else
        tmpl = obj.signal.templates;
        indx = cellfun(@(x) x.isEditable, tmpl);
        val  = tmpl(indx);
      end
    end
    
    function val = getTriggableTemplates(obj)
      if isempty(obj.signal)
        val = {};
      else
        tmpl = obj.signal.templates;
        indx = cellfun(@(x) x.isTriggable, tmpl);
        val  = tmpl(indx);
      end
    end
    
    function addTemplate(obj, template)
      obj.signal.addTemplate(template);
    end
    
    function val = getSelectedTemplate(obj)
      indx = obj.indxSelectedTemplate;
      if indx > 0
        templates  = obj.getEditableTemplates();
        val        = templates{indx};
      else
        val = [];
      end
    end
    
  end
end