classdef DefineTemplate < handle
  
  properties
    tLeft
    tRight
    time
    sweep
    plotMode = 'defineEpsp'
    axes0
    axes1
    templates
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
      obj.axes0 = subplot(211);
      obj.axes1 = subplot(212);
    end
    
    function val = get.indxSelectedTemplate(obj)
      val = obj.m_indxSelectedTemplate;
    end
    
    function set.indxSelectedTemplate(obj, val)
      obj.m_indxSelectedTemplate = val;
      obj.plotSweep;
    end
    
    function plotSweep(obj, time, sweep)
      
      if nargin==1
        time = obj.time;
        sweep = obj.sweep;
      else
        obj.time = time;
        obj.sweep = sweep;
      end
      
      cla(obj.axes0);
      grid(obj.axes0, 'on')
      hold(obj.axes0, 'on')
      plot(obj.axes0, time, sweep, 'HitTest', 'off')
      if strcmpi(obj.plotMode, 'defineEpsp')
        obj.axes0.ButtonDownFcn = @(~, ~) clickToDefineTemplate(obj);
      else
        template = obj.templates(obj.indxSelectedTemplate);
        vConv = template.convolute(obj.sweep);
        cla(obj.axes1)
        grid(obj.axes1, 'on')
        hold(obj.axes1, 'on')
        plot(obj.axes1, time, vConv);
        line(obj.axes1, xlim(obj.axes1), template.lowerThreshold*[1 1]);
        line(obj.axes1, xlim(obj.axes1), template.upperThreshold*[1 1]);
        ylim(obj.axes1, [0 2]);
        title(obj.axes1, sprintf('template #%d', obj.indxSelectedTemplate));
        linkaxes([obj.axes0 obj.axes1], 'x');
      end
      
    end
    
    function addTemplate(obj)
      obj.plotMode = 'defineEpsp';
      obj.plotSweep();
    end
    
    function clickToDefineTemplate(obj)
      currentPoint = obj.axes0.CurrentPoint;
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
  end
end