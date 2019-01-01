classdef Template < handle
  
  properties
    isUpdated   = false % true if getTriggerTimes() function return 
                        % accurately detected triggers
    isTriggable = true  % true to make template visible as trigger in GUI
    isEditable  = true  % true to make template editable in GUI
  end
  
  methods (Abstract)
    indx = match_v(obj, vInput, varargin)
    val = getTriggerTimes(obj)
  end
  
  properties (Dependent)
    dt
    parent
    tag
  end
  
  properties (SetAccess = 'private')
    m_parent
    m_tag
  end
  
  methods
    % Plot sweep customized for template
    %   obj     hamo.templates.Template subclass
    %   hAxes   Axes handle
    %   time    Time relative to trigger point
    %   sweep   Signal value corresponding to time values
    function plotSweep(obj, hAxes, time, sweep) %#ok<INUSL>
      plot(hAxes, time, sweep, 'b-');
    end
    
    % Plot template shape
    %   obj hamo.templates.Template subclass
    %   t0  Time point (x coordinate)
    %   v0  Signal value (y coordinate)
    function plotHandles = plotShape(obj, t0, v0) %#ok<INUSD>
      plotHandles = [];
    end
    
    % Plot template shape that can be edited
    %   obj hamo.templates.Template subclass
    %   t0  Time point (x coordinate)
    %   v0  Signal value (y coordinate)
    function plotEditableShape(obj, t0, v0) %#ok<INUSD>
    end
    
    function val = get.dt(obj)
      if ~isempty(obj.parent)
        val = obj.parent.dt;
      else
        val = [];
      end
    end
    
    function val = get.parent(obj)
      val = obj.m_parent;
    end
    
    function set.parent(obj, val)
      obj.m_parent = val;
      obj.changeParentNotifier();
    end
    
    function val = get.tag(obj)
      val = obj.m_tag;
    end
    
    function set.tag(obj, val)
      obj.m_tag = val;
    end
    
    function val = getFormattedTag(obj, mode)
      val = obj.tag;
      if nargin > 1
        if any(mode == '*') && ~obj.isUpdated
          val = ['*' val];
        end
      end
    end
  end
  
  methods (Access = 'protected')
    
    function changeParentNotifier(obj)
      obj.isUpdated = false;
    end
    
  end
end