classdef DefineTemplate < handle
  
  properties
    tLeft
    tRight
    time
    sweep
    triggerTime
    plotMode = 'defineEpsp'
    axes12
    axes22
    axes32
    axes31
    templates
    dt = 1e-5
  end
  
  properties (Dependent)
    indxSelectedTemplate
  end
  
  properties (SetAccess = 'private')
    m_indxSelectedTemplate = 1
  end
  
  methods
    
    function obj = DefineTemplate(fig)
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
      for i=1:length(obj.templates)
        t = obj.templates(i).getTriggerTimes(obj.dt);
        t = t(t>time(1)+triggerTime & t<time(end)+triggerTime);
        t = t - triggerTime;
        plot(obj.axes12, t, i*ones(size(t)), 'k+')
        plot(obj.axes12, [time(1) time(end)], i*[1 1], 'b-');
      end
      ylim(obj.axes12, [0 length(obj.templates)+1]);
      %obj.axes12.YTick = 1:length(obj.templates);
      
      cla(obj.axes22);
      grid(obj.axes22, 'on')
      hold(obj.axes22, 'on')
      plot(obj.axes22, time, sweep, 'HitTest', 'off')
      if strcmpi(obj.plotMode, 'defineEpsp')
        obj.axes22.ButtonDownFcn = @(~, ~) clickToDefineTemplate(obj);
      else
        obj.axes22.ButtonDownFcn = @(~, ~) clickToDrawTemplate(obj);
        
        template = obj.templates(obj.indxSelectedTemplate);
        cla(obj.axes31)
        hold(obj.axes31, 'on')
        grid(obj.axes31, 'on')
        plot(obj.axes31, (1:length(template.v))*obj.dt, template.v)
        
        vConv = template.convolute(obj.sweep);
        cla(obj.axes32)
        grid(obj.axes32, 'on')
        hold(obj.axes32, 'on')
        plot(obj.axes32, time, vConv);
        line(obj.axes32, [time(1) time(end)], template.lowerThreshold*[1 1]);
        line(obj.axes32, [time(1) time(end)], template.upperThreshold*[1 1]);
        ylim(obj.axes32, [0 2]);
        title(obj.axes32, sprintf('template #%d', obj.indxSelectedTemplate));
      end
      linkaxes([obj.axes12 obj.axes22 obj.axes32], 'x');
      xlim(obj.axes12, [time(1) time(end)])
    end
    
    function addTemplate(obj)
      obj.plotMode = 'defineEpsp';
      obj.plotSweep();
    end
    
    function clickToDefineTemplate(obj)
      currentPoint = obj.axes22.CurrentPoint;
      if isempty(obj.tLeft)
        obj.tLeft = currentPoint(1);
      elseif isempty(obj.tRight)
        obj.tRight = currentPoint(1);
        obj.templates = add_to_list(obj.templates, ...
          hamo.templates.ConvTemplate(obj.sweep(obj.time >= obj.tLeft & obj.time <= obj.tRight)));
        obj.plotMode = 'plotSweep';
        obj.indxSelectedTemplate = length(obj.templates);
        obj.tLeft  = [];
        obj.tRight = [];
      end
    end
    
    function clickToDrawTemplate(obj)
      currentPoint = obj.axes22.CurrentPoint;
      x = currentPoint(1);
      template = obj.templates(obj.indxSelectedTemplate);
      plot(obj.axes22, x+(1:length(template.v))*obj.dt, template.v, ...
        'HitTest', 'off');
    end
    
    function updateTemplates(obj, v)
      for i=1:length(obj.templates)
        obj.templates(i).indxDetected = ...
          obj.templates(i).match(v);
        obj.templates(i).isUpdated = true;
      end
    end
    
  end
end