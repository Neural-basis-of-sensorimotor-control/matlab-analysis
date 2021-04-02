classdef SequenceViewer < ExperimentWrapper
  
  methods (Abstract, Static)
    mode            %see ScGuiState enums
  end
  
  methods (Abstract)
    
    %Add panels that will never be deleted during usage
    add_constant_panels(obj)
    
    %Add panels that can be deleted and reconstructed when data has
    %changed
    add_dynamic_panels(obj)
    
    %Delete deletable panels
    delete_dynamic_panels(obj)
    
  end
  
  properties (Dependent, Abstract)
    
    triggertimes
    nbr_of_constant_panels
    
  end
  
  properties (Constant)
    
    panel_width = 205
    
    row_margin   = 40
    upper_margin = 10
    left_margin  = 120
    right_margin = 40
    
    figure_tag = 'sensorimotor-control'
    
  end
  
  properties (SetObservable)
    
    parent              %GuiManager
    panels              %CascadeList
    btn_window          %Figure
    digital_channels    %DigitalAxes
    analog_subch        %ScCellList
    histogram           %HistogramChannel
    rmwf                %ScRemoveWaveform
    help_text           %char array
    main_channel        %AnalogAxes
    
    nbr_of_analog_channels
    zoom_on             = 0
    pan_on              = 0
    debug_indent        = 0
    automatic_update_on = true
    
  end
  
  properties
    
    zoom_controls           %uicontrol array
    filepath                %char array
    reset_btn               %uicontrol
    
    plot_window_pr          %Figure
    histogram_window_pr     %Figure
    rasterplot_window_pr    %Figure
    
    show_stim_channels     = true
    
  end
  
  properties (Dependent)
    
    plots
    analog_ch
    main_signal
    main_axes
    show_digital_channels
    show_histogram
    
    plot_window
    histogram_window
    rasterplot_window
    
  end
  
  properties (SetAccess = 'private', GetAccess = 'private')
    deletechannel
  end
  
  methods
    
    %obj.create_channels must be called in inheriting class right
    %after calling SequenceViewer constructor
    function obj = SequenceViewer(guimanager)
      
      obj.btn_window = figure('Tag', SequenceViewer.figure_tag);
      obj.plot_window = figure('Tag', SequenceViewer.figure_tag);
      obj.setup_listeners();
      obj.zoom_controls = ScList();
      obj.parent = guimanager;
    
    end
    
    
    %override to use customized channel classes
    function create_channels(obj)
      
      obj.analog_subch = ScCellList();
      obj.main_channel = AnalogAxes(obj);
      setheight(obj.main_channel,450);
      obj.digital_channels = DigitalAxes(obj);
      obj.histogram = HistogramChannel(obj);
    
    end
    
    
    function add_reset_panel(obj)
    
      obj.panels.add(UpdatePanel(obj));
      obj.panels.add(ModePanel(obj));
    
    end
    
    
    function analog_ch = get.analog_ch(obj)
    
      analog_ch = ScCellList();
      analog_ch.add(obj.main_channel);
      
      for k=1:obj.analog_subch.n
        analog_ch.add(obj.analog_subch.get(k));
      end
      
    end
    
    
    function plots = get.plots(obj)
    
      plots = ScCellList();
      
      if ~isempty(obj.digital_channels)
        plots.add(obj.digital_channels);
      end
      
      for k=1:obj.analog_ch.n
        plots.add(obj.analog_ch.get(k));
      end
      
    end
    
    
    function main_signal = get.main_signal(obj)
      main_signal = obj.main_channel.signal;
    end
    
    
    function main_axes = get.main_axes(obj)
      main_axes = obj.main_channel.ax;
    end
    
    
    function val = get.show_digital_channels(obj)
      val = ~isempty(obj.digital_channels);
    end
    
    
    function val = get.show_histogram(obj)
      val = ~isempty(obj.histogram);
    end
    
    
    function val = get.plot_window(obj)
      
      if isempty(obj.plot_window_pr) || ~ishandle(obj.plot_window_pr)
        
        obj.plot_window_pr = figure();
        clf(obj.plot_window_pr,'reset');
        set(obj.plot_window_pr, 'Tag', SequenceViewer.figure_tag)
        set(obj.plot_window_pr,'ToolBar','None','MenuBar','none');
        set(obj.plot_window_pr,'Color',[0 0 0]);
        set(obj.plot_window_pr,'SizeChangedFcn',@(~,~) obj.resize_plot_window());
      
      end
      
      val = obj.plot_window_pr;
    
    end
    
    
    function set.plot_window(obj,val)
    
      obj.plot_window_pr = val;
      set(obj.plot_window_pr, 'Tag', SequenceViewer.figure_tag)
    
    end
    
    
    function val = get.histogram_window(obj)
      
      if isempty(obj.histogram_window_pr) || ~ishandle(obj.histogram_window_pr)
        
        obj.histogram_window_pr = figure('Color',[0 0 0],...
          'SizeChangedFcn',@(~,~) obj.resize_histogram_window, ...
          'Tag', SequenceViewer.figure_tag);
        
        if ~isempty(obj.histogram)
          
          set(obj.histogram,'Parent',obj.histogram_window_pr);
          
          if isempty(obj.histogram.ax) || ~ishandle(obj.histogram.ax)
            obj.histogram.ax = axes;
          end
          
        end
      end
      
      val = obj.histogram_window_pr;
    
    end
    
    
    function set.histogram_window(obj,val)
      
      obj.histogram_window_pr = val;
      set(obj.histogram_window_pr, 'Tag', SequenceViewer.figure_tag);
    
    end
    
    
    function val = get.rasterplot_window(obj)
      
      if isempty(obj.rasterplot_window_pr) || ~ishandle(obj.rasterplot_window_pr)
        obj.rasterplot_window_pr = figure('Tag', SequenceViewer.figure_tag);
      end
      
      val = obj.rasterplot_window_pr;
    
    end
    
    
    function set.rasterplot_window(obj,val)
      
      obj.rasterplot_window_pr = val;
      set(obj.rasterplot_window_pr, 'Tag', SequenceViewer.figure_tag)
    
    end
    
  end
end
