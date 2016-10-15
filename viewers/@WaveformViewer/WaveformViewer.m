classdef WaveformViewer < SequenceViewer

  properties (SetObservable, SetAccess='private')
    triggerparent
    trigger
    waveform
  end

  properties (Dependent)
    triggerparents
    triggers
    triggertimes
    nbr_of_constant_panels
  end

  methods (Static)
    function enum = mode
      enum = ScGuiState.spike_detection;
    end
  end

  methods
    function obj = WaveformViewer(guimanager,varargin)
      obj@SequenceViewer(guimanager,varargin{:});
      obj.create_channels();
    end

    function add_constant_panels(obj)
      obj.panels.add(InfoPanel(obj));
    end

    function add_dynamic_panels(obj)    
      obj.panels.add(WfChannelPanel(obj));
      obj.panels.add(WfPlotPanel(obj));
      obj.panels.add(HistogramPanel(obj));
    end

    function delete_dynamic_panels(obj)
      %todo - replace hardcoded number with function
      for k=obj.panels.n:-1:obj.nbr_of_constant_panels+1
        panel = obj.panels.get(k);
        obj.panels.remove(panel);
        delete(panel);
      end
    end

    function triggerparents = get.triggerparents(obj)
      if isempty(obj.sequence)
        triggerparents = [];
      else
        triggerparents = obj.sequence.gettriggerparents(obj.tmin,obj.tmax);
      end
    end

    function triggers = get.triggers(obj)
      if isempty(obj.triggerparent)
        triggers = [];
      else
        triggers = obj.triggerparent.triggers;
      end
    end

    function triggertimes = get.triggertimes(obj)
      if isempty(obj.trigger)
        triggertimes = [];
      else
        triggertimes = obj.trigger.gettimes(obj.tmin,obj.tmax);
      end
    end

    function ret = get.nbr_of_constant_panels(~)
      ret = 3;
    end

	end
end
