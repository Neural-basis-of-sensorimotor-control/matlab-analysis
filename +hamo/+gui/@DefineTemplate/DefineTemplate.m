classdef DefineTemplate < handle
  
  properties (Transient)
    axes12
    axes22
    axes32
    axes31
    ephemeralPlots
    v
    v_raw
  end
  
  properties
    tLeft
    tRight
    plotMode = 'plotSweep'
  end
  
  % Public properties with getters and setters and corresponding private
  % member variables
  properties (Dependent)
    signal
    indxSelectedTemplate
    trigger
    pretrigger
    posttrigger
    triggerTimes
    triggerIndx
    rectificationPoint
    triggerIncr
    plotRawData = false
  end
  
  % Private member variables, to be accessed only through getter and setter
  % functions for Dependent properties
  properties (SetAccess = 'private')
    m_indxSelectedTemplate = 1
    m_signal
    m_trigger
    m_pretrigger   = -5e-3
    m_posttrigger  = 3e-2
    m_triggerTimes = 1
    m_triggerIndx  = 1
    m_rectificationPoint = []
    m_triggerIncr = 1
    m_plotRawData
  end
  
  methods
    
    function obj = DefineTemplate(signal, fig)
      obj.signal = signal;
      clf(fig);
      obj.axes12 = subplot(3, 5, 2:5);
      obj.axes22 = subplot(3, 5, 5+(2:5));
      obj.axes32 = subplot(3, 5, 10+(2:5));
      obj.axes31 = subplot(3, 5, 11);
      linkaxes([obj.axes12 obj.axes22], 'x');
    end
    
    % Getters and setters
    function val = get.triggerIncr(obj)
      val = obj.m_triggerIncr;
    end
    
    function set.triggerIncr(obj, val)
      obj.m_triggerIncr = val;
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
      if length(obj.triggerIndx) ~= length(val)
        obj.triggerIncr = length(val);
      end
      obj.m_triggerIndx = val;
      obj.plotSweep();
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
    
  end
end