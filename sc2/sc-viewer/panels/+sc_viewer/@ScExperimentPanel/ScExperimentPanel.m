classdef ScExperimentPanel < sc_viewer.ScViewerComponent
  
  properties
    
    ui_experiment
    ui_file
    ui_sequence
    ui_signal1
    ui_signal2
    ui_waveform
    ui_amplitude
    
  end
  
  methods (Static)
    
    function ui_panel = get_panel(viewer)
      
      ui_panel = uipanel(viewer.button_window, 'Title', 'Experiment');
      panel    = sc_viewer.ScExperimentPanel(ui_panel, viewer);
      mgr      = sc_layout.PanelLayoutManager(ui_panel);

      mgr.add(sc_ctrl('text', 'Experiment'), 100);
      panel.ui_experiment = mgr.add(sc_ctrl('text', ''), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'File'), 100);
      panel.ui_file = mgr.add(sc_ctrl('popupmenu', '', @(~, ~) file_callback(panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Sequence'), 100);
      panel.ui_sequence = mgr.add(sc_ctrl('popupmenu', '', @(~, ~) sequence_callback(panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Signal1'), 100);
      panel.ui_signal1 = mgr.add(sc_ctrl('popupmenu', '', @(~, ~) signal1_callback(panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Signal2'), 100);
      panel.ui_signal2 = mgr.add(sc_ctrl('popupmenu', '', @(~, ~) signal2_callback(panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Waveform'), 100);
      panel.ui_waveform = mgr.add(sc_ctrl('popupmenu', '', @(~, ~) waveform_callback(panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Amplitude'), 100);
      panel.ui_amplitude = mgr.add(sc_ctrl('popupmenu', '', @(~, ~) amplitude_callback(panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.trim();
      
      sc_addlistener(panel.viewer, 'experiment', ...
        @(~, ~) panel.experiment_listener(), ui_panel);
      
      sc_addlistener(panel.viewer, 'file', ...
        @(~, ~) panel.file_listener(), ui_panel);
      
      sc_addlistener(panel.viewer, 'sequence', ...
        @(~, ~) panel.sequence_listener(), ui_panel);
      
      sc_addlistener(panel.viewer, 'signal1', ...
        @(~, ~) panel.signal1_listener(), ui_panel);
      
      sc_addlistener(panel.viewer, 'signal2', ...
        @(~, ~) panel.signal2_listener(), ui_panel);
      
      sc_addlistener(panel.viewer, 'waveform', ...
        @(~, ~) panel.waveform_listener(), ui_panel);
      
      sc_addlistener(panel.viewer, 'amplitude', ...
        @(~, ~) panel.amplitude_listener(), ui_panel);
      
      panel.experiment_listener();
      panel.file_listener();
      panel.sequence_listener();
      panel.signal1_listener();
      panel.signal2_listener();
      panel.waveform_listener();
      panel.amplitude_listener();
      
    end
    
  end
  
  
  methods
    
    function obj = ScExperimentPanel(panel, viewer)
      obj@sc_viewer.ScViewerComponent(panel, viewer);
    end
    
  end
  
  methods (Access = 'private')
    
    function file_callback(obj)
      
      indx = get(obj.ui_file, 'Value');
      obj.viewer.set_file(obj.viewer.experiment.get(indx));
      
    end
    
    
    function sequence_callback(obj)
      
      indx = get(obj.ui_sequence, 'Value');
      obj.viewer.set_sequence(obj.viewer.file.get(indx));
      
    end
    
    
    function signal1_callback(obj)
      
      indx = get(obj.ui_signal1, 'Value');
      obj.viewer.set_signal1(obj.viewer.file.signals.get(indx));
      
    end
    
    
    function signal2_callback(obj)
      
      indx = get(obj.ui_signal2, 'Value');
      obj.viewer.set_signal2(obj.viewer.file.signals.get(indx));
      
    end
    
    
    function waveform_callback(obj)
      
      indx = get(obj.ui_waveform, 'Value');
      obj.viewer.set_waveform(obj.viewer.signal1.waveforms.get(indx));
      
    end
    
    
    function amplitude_callback(obj)
      
      indx = get(obj.ui_amplitude, 'Value');
      obj.viewer.set_amplitude(obj.viewer.signal1.amplitudes.get(indx));
      
    end
    
    
    function experiment_listener(obj)
      
      if ~isempty(obj.viewer.experiment)
        str =  obj.viewer.experiment.save_name;
      else
        str = [];
      end
      
      set(obj.ui_experiment, 'String', str);
      
    end
    
    
    function file_listener(obj)
      
      if ~isempty(obj.viewer.file)
        
        str  = obj.viewer.experiment.values('tag');
        indx = find(cellfun(@(x) strcmp(x, obj.viewer.file.tag), str));
        
        if ~isempty(indx)
          set(obj.ui_file, 'String', str, 'Value', indx, 'Visible', 'on');
        else
          set(obj.ui_file, 'Visible', 'off');
        end
        
      else
        set(obj.ui_file, 'Visible', 'off');
      end
      
    end
    
    
    function sequence_listener(obj)
      
      if ~isempty(obj.viewer.sequence)
        
        str  = obj.viewer.file.values('tag');
        indx = find(cellfun(@(x) strcmp(x, obj.viewer.sequence.tag), str));
        
        if ~isempty(indx)
          set(obj.ui_sequence, 'String', str, 'Value', indx, 'Visible', 'on');
        else
          set(obj.ui_sequence, 'Visible', 'off');
        end
        
      else
        
        set(obj.ui_sequence, 'Visible', 'off');
        
      end
      
    end
    
    
    function signal1_listener(obj)
      
      if ~isempty(obj.viewer.signal1)
        
        str  = obj.viewer.file.signals.values('tag');
        indx = find(cellfun(@(x) strcmp(x, obj.viewer.signal1.tag), str));
        
        if ~isempty(indx)
          set(obj.ui_signal1, 'String', str, 'Value', indx, 'Visible', 'on');
        else
          set(obj.ui_signal1, 'Visible', 'off');
        end
        
      else
        
        set(obj.ui_signal1, 'Visible', 'off');
        
      end
      
    end
    
    function signal2_listener(obj)
      
      if ~isempty(obj.viewer.signal2)
        
        str  = obj.viewer.file.signals.values('tag');
        indx = find(@(x) strcmp(x, obj.viewer.signal2.tag), str);
        
        if ~isempty(indx)
          set(obj.ui_signal2, 'String', str, 'Value', indx, 'Visible', 'on');
        else
          set(obj.ui_signal2, 'Visible', 'off');
        end
        
      else
        
        set(obj.ui_signal2, 'Visible', 'off');
        
      end
      
    end
    
    
    function waveform_listener(obj)
      
      if ~isempty(obj.viewer.waveform)
        
        str  = obj.viewer.signal1.waveforms.values('tag');
        indx = find(cellfun(@(x) strcmp(x, obj.viewer.waveform.tag), str));
        
        if ~isempty(indx)
          set(obj.ui_waveform, 'String', str, 'Value', indx, 'Visible', 'on');
        else
          set(obj.ui_waveform, 'Visible', 'off');
        end
        
      else
        
        set(obj.ui_waveform, 'Visible', 'off');
        
      end
      
    end
    
    
    function amplitude_listener(obj)
      
      if  ~isempty(obj.viewer.amplitude)
        
        str  = obj.viewer.signal1.amplitudes.values('tag');
        indx = find(cellfun(@(x) strcmp(x, obj.viewer.amplitude.tag), str));
        
        if ~isempty(indx)
          set(obj.ui_amplitude, 'String', str, 'Value', indx, 'Visible', 'on');
        else
          set(obj.ui_amplitude, 'Visible', 'off');
        end
        
      else
        
        set(obj.ui_amplitude, 'Visible', 'off');
        
      end
      
    end
    
  end
end