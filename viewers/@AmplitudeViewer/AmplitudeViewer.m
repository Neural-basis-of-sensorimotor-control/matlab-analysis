classdef AmplitudeViewer < SequenceViewer & IntraAmplitudeViewer

  properties (SetObservable, SetAccess = 'private')
    amplitude
    mouse_press = 1
  end

  properties (Dependent)
    triggertimes
    nbr_of_constant_panels
  end

  properties
    amplitude_computed_channel
    amplitude_average_channel
  end

  methods

    function obj = AmplitudeViewer(guimanager, varargin)
      obj@SequenceViewer(guimanager, varargin{:});
      obj.create_channels();
    end

    %Overriding method in SequenceViewer
    function create_channels(obj)
      obj.analog_subch = ScCellList();
      obj.main_channel = AmplAnalogAxes(obj);
      setheight(obj.main_channel,450);
      obj.digital_channels = DigitalAxes(obj);

      obj.amplitude_computed_channel = AmplitudeComputedChannel(obj);
      obj.amplitude_average_channel = AmplitudeAverageChannel(obj);

      obj.histogram = [];
    end

    function plot_channels(obj)
      plot_channels@SequenceViewer(obj);
      obj.amplitude_computed_channel.update();
    end

    function add_constant_panels(obj)
      obj.panels.add(InfoPanel(obj));
    end

    function add_dynamic_panels(obj)
      obj.panels.add(AmplChannelPanel_(obj));
      obj.panels.add(AmplPlotPanel(obj));
    end

    function delete_dynamic_panels(obj)
      for k=obj.panels.n:-1:obj.nbr_of_constant_panels+1
        panel = obj.panels.get(k);
        obj.panels.remove(panel);
        delete(panel);
      end
    end

    function set_amplitude(obj,amplitude)
      obj.amplitude = amplitude;
      if ~isempty(obj.amplitude) && numel(obj.triggertimes)
        obj.set_mouse_press(1);
      end
      obj.amplitude_average_channel.update();
    end

    function set_sweep(obj,sweep)
      obj.sweep = mod(sweep-1,numel(obj.triggertimes))+1;
      if ~isempty(obj.amplitude) && numel(sweep)
        triggertime = obj.triggertimes(obj.sweep(1));
        val = obj.amplitude.get_data(triggertime,[1 3]);
        mousepress = find(isnan(val),1);
        if isempty(mousepress)
          obj.set_mouse_press(0);
        else
          obj.set_mouse_press(mousepress);
        end
      end
    end

    function set_mouse_press(obj,val)
      obj.mouse_press = val;
      if obj.mouse_press ==1 || obj.mouse_press == 2
        obj.help_text = sprintf('Awaiting mouse press #%i',obj.mouse_press);
      else
        obj.help_text = 'Amplitude is set for this sweep';
      end
      obj.plot_channels();
    end

    function ret = get.triggertimes(obj)
      if isempty(obj.amplitude)
        ret = [];
      else
        ret = obj.amplitude.gettimes(obj.tmin,obj.tmax);
      end
    end

    function ret = get.nbr_of_constant_panels(~)
      ret = 3;
    end

  end

  methods (Static)

    function val = mode(~)
      val = ScGuiState.ampl_analysis;
    end
  end
end
