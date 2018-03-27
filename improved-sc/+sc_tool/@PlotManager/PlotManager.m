classdef PlotManager < sc_tool.ExperimentManager & ...
    sc_tool.AxesHeightManager & sc_tool.TimeRangeManager & ...
    sc_tool.ZoomManager & sc_tool.UnsavedChangesManager & ...
    sc_tool.HelpTextManager & sc_tool.WaveformManager & ...
    sc_tool.AmplitudeManager & sc_tool.HistogramManager & ...
    sc_tool.InteractivePlotManager & sc_tool.EnableManager
  
  properties
    plot_window
  end
  
  properties (Dependent)
    plot_mode
    v_zero_for_t
    plot_stims
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_plot_mode
    m_v_zero_for_t
    m_plot_stims
  end
  
  methods
    
    function obj = PlotManager()
      
      filepath = sc_file_loader.get_experiment_file();
      
      if isempty(filepath)
        
        fprintf('Could not detect file\n');
        return;
        
      end
      
      obj.plot_window = figure('ToolBar', 'none', 'Color', 'k', ...
        'Tag', SequenceViewer.figure_tag, 'MenuBar', 'none');
      
      set(obj.plot_window, 'SizeChangedFcn', ...
        @(~,~) update_axes_position(obj), ...
        'CloseRequestFcn', @(~, ~) obj.close_request(), ...
        'DeleteFcn', @(~, ~) obj.save_plot_window_pos());
      
      obj.plot_stims = 1;
      obj.plot_mode = sc_tool.PlotModeEnum.plot_sweep;
      
      obj.experiment = ScExperiment.load_experiment(filepath);
      
    end
    
  end
  
  methods
    % Getters and setters
    
    function val = get.plot_mode(obj)
      val = obj.m_plot_mode;
    end
    
    function set.plot_mode(obj, val)
      
      if obj.interactive_mode  
        obj.interactive_mode = false;
      end
      
      obj.m_plot_mode = val;
      obj.update_plots();
      
    end
    
    function val = get.v_zero_for_t(obj)
      val = obj.m_v_zero_for_t;
    end
    
    function set.v_zero_for_t(obj, val)
      obj.m_v_zero_for_t = val;
    end
    
    function val = get.plot_stims(obj)
      val = obj.m_plot_stims;
    end
    
    function set.plot_stims(obj, val)
      obj.m_plot_stims = val;
    end
    
  end
end