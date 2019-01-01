classdef DefineTemplate < handle
  
  properties
    tLeft
    tRight
    time
    sweep
    triggerTime
    plotMode = 'defineConvTemplate'
    axes12
    axes22
    axes32
    axes31
    dt = 1e-5
    ephemeralPlots
    signal
  end
  
  properties (Dependent)
    indxSelectedTemplate
  end
  
  properties (SetAccess = 'private')
    m_indxSelectedTemplate = 1
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
    
    function val = get.indxSelectedTemplate(obj)
      val = obj.m_indxSelectedTemplate;
    end
    
    function set.indxSelectedTemplate(obj, val)
      obj.m_indxSelectedTemplate = val;
      obj.plotSweep;
    end
    
    function plotSweep(obj, time, sweep, triggerTime)
      
      if nargin==1
        time = obj.time;
        sweep = obj.sweep;
        triggerTime = obj.triggerTime;
      else
        obj.time = time;
        obj.sweep = sweep;
        obj.triggerTime = triggerTime;
      end
      
      cla(obj.axes12)
      hold(obj.axes12, 'on')
      grid(obj.axes12, 'on')
      triggableTemplates = obj.getTriggableTemplates();
      for i=1:length(triggableTemplates)
        template = triggableTemplates{i};
        t = template.getTriggerTimes();
        t = t(t>time(1)+triggerTime & t<time(end)+triggerTime);
        t = t - triggerTime;
        plot(obj.axes12, t, i*ones(size(t)), 'k+')
        plot(obj.axes12, [time(1) time(end)], i*[1 1], 'b-');
      end
      ylim(obj.axes12, [0 length(obj.getTriggableTemplates())+1]);
      obj.axes12.YTick = 1:length(obj.getTriggableTemplates());
      obj.axes12.YTickLabel = cellfun(@(x) getFormattedTag(x, '*'), ...
        obj.getTriggableTemplates(), 'UniformOutput', false);
      
      cla(obj.axes22);
      grid(obj.axes22, 'on')
      hold(obj.axes22, 'on')
      plot(obj.axes22, time, sweep, 'HitTest', 'off')
      if strcmpi(obj.plotMode, 'defineConvTemplate') ||...
          strcmpi(obj.plotMode, 'defineAutoThreshold')
        obj.axes22.ButtonDownFcn = @(~, ~) clickToDefineTemplate(obj);
      else
        obj.axes22.ButtonDownFcn = @(~, ~) clickToDrawTemplate(obj);        
        template = obj.getSelectedTemplate();
        cla(obj.axes31)
        template.plotShape(obj.axes31, 0, 0);
        grid(obj.axes31, 'on')
        
        cla(obj.axes32)
        grid(obj.axes32, 'on')
        hold(obj.axes32, 'on')
        template.plotSweep(obj.axes32, time, sweep);
        title(obj.axes32, sprintf('template #%d', obj.indxSelectedTemplate));
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
        v = obj.sweep(obj.time >= obj.tLeft & obj.time <= obj.tRight);
        if strcmpi(obj.plotMode, 'defineConvTemplate')
          template = hamo.templates.ConvTemplate(v);
        elseif strcmpi(obj.plotMode, 'defineAutoThreshold')
          template = hamo.templates.AutoThresholdTemplate(v);
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
    
    function updateTemplates(obj, v)
      triggableTemplates = obj.getTriggableTemplates();
      for i=1:length(triggableTemplates)
        template = triggableTemplates{i};
        if ~template.isUpdated
          template.triggerIndx = ...
            template.match_v(v);
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
      templates  = obj.getEditableTemplates();
      val        = templates{obj.indxSelectedTemplate};
    end
    
  end
end