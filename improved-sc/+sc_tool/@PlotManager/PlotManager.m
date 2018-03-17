classdef PlotManager < sc_tool.ExperimentManager & ...
    sc_tool.AxesHeightManager & sc_tool.TimeRangeManager & ...
    sc_tool.ZoomManager & sc_tool.UnsavedChangesManager & ...
    sc_tool.HelpTextManager & sc_tool.WaveformManager & ...
    sc_tool.AmplitudeManager
  
  properties
    plot_window
  end
  
  properties (Dependent)
    plot_mode
  end
  
  properties (SetAccess = 'private', SetObservable)
    m_plot_mode = sc_tool.PlotModeEnum.plot_sweep
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
    
  end
  
  methods
    % Getters and setters
    
    function val = get.plot_mode(obj)
      val = obj.m_plot_mode;
    end
    
    function set.plot_mode(obj, val)
      
      if val == sc_tool.PlotModeEnum.plot_amplitude && ...
          isempty(obj.amplitude)
        
        warning('No amplitudes available. Cannot use amplitude plot mode.')
        val = sc_tool.PlotModeEnum.plot_sweep;
        
      end
      
      if obj.m_plot_mode == sc_tool.PlotModeEnum.edit_threshold && ...
          ~isempty(obj.modify_waveform) && ...
          val ~= sc_tool.PlotModeEnum.edit_threshold
        
        if obj.modify_waveform.has_unsaved_changes
          
          answ = questdlg('Do you want to save waveform edits?');
          
          if strcmpi(answ, 'Yes')
            
            obj.sc_save();
            obj.modify_waveform = [];
            
          elseif strcmpi(answ, 'No')
            
            obj.modify_waveform = [];
            
          else
            
            obj.m_plot_mode = sc_tool.PlotModeEnum.edit_threshold;
            
          end
          
        end
      end
      
      obj.m_plot_mode = val;
      obj.update_plots();
      
    end
    
  end
end