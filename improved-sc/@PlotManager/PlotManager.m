classdef PlotManager < ExperimentManager & AxesHeightManager & TimeRangeManager & ...
    ZoomManager & UnsavedChangesManager & HelpTextManager
  
  properties
    plot_window
  end
  
  properties (Dependent)
    plot_mode
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_plot_mode = PlotModeEnum.plot_sweep
  end
  
  methods
    
    function obj = PlotManager()
      
      [~, filename] = sc_settings.get_last_experiment();

      if ~isfile(filename)
        
        [fname, pname] = uigetfile('*_sc.mat', 'Choose experiment file');
        filename       = fullfile(pname, fname);
        
        if ~isfile(filename)
          
          fprintf('Could not detect file\n');
          return;
          
        end
        
      end
      
      obj.plot_window = figure('ToolBar', 'none', 'Color', 'k');
      set(obj.plot_window, 'SizeChangedFcn', @(~,~) update_axes_position(obj));
      sc_settings.set_default_experiment_dir(filename);
      obj.experiment = ScExperiment.load_experiment(filename);
      
    end
    
    
    function update_plots(obj)
      
      cla(obj.signal1_axes);
      hold(obj.signal1_axes, 'on');
      
      if isempty(obj.signal1)
        return
      end
      
      xlim(obj.signal1_axes, [obj.pretrigger obj.posttrigger]);
      xlabel(obj.signal1_axes, 'Time [s]');
      ylabel(obj.signal1_axes, obj.signal1.tag);
      set(obj.signal1_axes, 'XColor', [1 1 1], 'YColor', [1 1 1], 'Color', ...
        [0 0 0], 'Box', 'off');
      grid(obj.signal1_axes,'on');
      
      switch obj.plot_mode
        case PlotModeEnum.plot_sweep
          obj.plot_sweep();
        case PlotModeEnum.plot_amplitude
          obj.plot_amplitude();
        case PlotModeEnum.edit_threshold
          obj.plot_edit_waveform();
      end
            
    end
    
  end
  
  methods
    % Getters and setters
    
    function val = get.plot_mode(obj)
      val = obj.m_plot_mode;
    end
    
    function set.plot_mode(obj, val)
      
      if val == PlotModeEnum.plot_amplitude && isempty(obj.amplitude)
        
        warning('No amplitudes available. Cannot use amplitude plot mode.')
        val = PlotModeEnum.plot_sweep;
        
      end
      
      obj.m_plot_mode = val;
      obj.update_plots();
      
    end
    
  end
end