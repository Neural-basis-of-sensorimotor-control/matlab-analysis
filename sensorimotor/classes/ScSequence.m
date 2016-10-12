classdef ScSequence < ScListElement
%Certain time range of a file

  properties
    tag
    comment
    tmin
    tmax
  end

  properties (Dependent)
    filepath
    channels
    fdir

    signals
    stims
    textchannels
  end

  methods
    function obj = ScSequence(parent, tag, tmin, tmax)
      obj.parent = parent;
      obj.tag = tag;
      obj.tmin = tmin;
      if nargin>3
        obj.tmax = tmax;
      end
    end

    %clear all transient data
    function sc_clear(obj)
      ch = obj.channels;
      for i=1:ch.n
        ch.get(i).sc_clear();
      end
    end

    function filepath = get.filepath(obj)
      filepath = obj.parent.filepath;
    end

    function channels = get.channels(obj)
      channels = obj.parent.channels;
    end

    function fdir = get.fdir(obj)
      fdir = obj.parent.fdir;
    end

    function triggerparents = gettriggerparents(obj,tmin,tmax)
      triggerparents = obj.parent.gettriggerparents(tmin,tmax);
      triggerparents.add(ScClockTriggerParent(obj));
    end

    function triggers = gettriggers(obj,tmin,tmax)
      triggers = obj.parent.gettriggers(tmin,tmax);
    end

    function signals = get.signals(obj)
      signals = obj.parent.signals;
    end

    function stims = get.stims(obj)
      stims = obj.parent.stims;
    end

    function textchannels = get.textchannels(obj)
      textchannels = obj.parent.textchannels;
    end
    function saved = sc_save(obj)
      saved = obj.parent.sc_save();
    end
  end

end
