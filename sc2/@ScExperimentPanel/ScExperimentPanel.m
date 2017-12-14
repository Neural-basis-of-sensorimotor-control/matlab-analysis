classdef ScExperimentPanel < ScGuiComponent
  
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
    
    function panel = get_panel(viewer)
      
      expr_panel = ScExperimentPanel(viewer);
      panel      = uipanel(info_panel.viewer.btn_window, 'Title', ...
        'Experiment');
      mgr        = ScLayoutManager(panel);
      
      mgr.add(sc_ctrl('text', 'Experiment'), 100);
      mgr.add(sc_ctrl('text', ''), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'File'), 100);
      mgr.add(sc_ctrl('popupmenu', '', @(~, ~) file_callback(expr_panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Signal1'), 100);
      mgr.add(sc_ctrl('popupmenu', '', @(~, ~) signal1_callback(expr_panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Signal2'), 100);
      mgr.add(sc_ctrl('popupmenu', '', @(~, ~) signal2_callback(expr_panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Waveform'), 100);
      mgr.add(sc_ctrl('popupmenu', '', @(~, ~) waveform_callback(expr_panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.add(sc_ctrl('text', 'Amplitude'), 100);
      mgr.add(sc_ctrl('popupmenu', '', @(~, ~) amplitude_callback(expr_panel), ...
        'Visible', 'off'), 100);
      mgr.newline();
      
      mgr.trim();
      
      sc_addlistener(obj.viewer, 'experiment', ...
        @(~, ~) obj.experiment_listener(), panel);
      
      sc_addlistener(obj.viewer, 'file', ...
        @(~, ~) obj.experiment_listener(), panel);
      
      sc_addlistener(obj.viewer, 'waveform', ...
        @(~, ~) obj.experiment_listener(), panel);
      
      sc_addlistener(obj.viewer, 'signal1', ...
        @(~, ~) obj.experiment_listener(), panel);
      
      
      sc_addlistener(obj.viewer, 'signal2', ...
        @(~, ~) obj.experiment_listener(), panel);
      
      sc_addlistener(obj.viewer, 'waveform', ...
        @(~, ~) obj.experiment_listener(), panel);
      
      sc_addlistener(obj.viewer, 'amplitude', ...
        @(~, ~) obj.experiment_listener(), panel);
      
    end
    
  end
  
  
  methods
    
    function obj = ScExperimentPanel(viewer)
      obj@ScGuiComponent(viewer);
    end
    
  end
  
  methods (Access = 'private')
    
    function file_callback(obj)
      
      indx = get(obj.ui_file, 'Value');
      obj.viewer.set_file(obj.experiment.get(indx));
      
    end
    
    
    function sequence_callback(obj)
      
      indx = get(obj.ui_sequence, 'Value');
      obj.viewer.set_sequence(obj.file.get(indx));
      
    end
    
    
    function signal1_callback(obj)
      
      indx = get(obj.ui_signal1, 'Value');
      obj.viewer.set_signal1(obj.file.signals.get(indx));
      
    end
    
    
    function signal2_callback(obj)
      
      indx = get(obj.ui_signal2, 'Value');
      obj.viewer.set_signal2(obj.file.signals.get(indx));
      
    end
    
    
    function waveform_callback(obj)
      
      indx = get(obj.ui_waveform, 'Value');
      obj.viewer.set_waveform(obj.file.waveforms.get(indx));
      
    end
    
    
    function amplitude_callback(obj)
      
      indx = get(obj.ui_amplitude, 'Value');
      obj.viewer.set_waveform(obj.file.amplitudes.get(indx));
      
    end
    
    
    function experiment_listener(obj)
      
      if ~isempty(obj.viewer.experiment)
        str =  obj.viewer.experiment.tag;
      else
        str = [];
      end
      
      set(obj.ui_experiment, 'String', str);
      
    end
    
    
    function file_listener(obj)
      
      if ~isempty(obj.viewer.experiment) && ~isempty(obj.viewer.file)
        
        str  = obj.viewer.experiment.values('tag');
        indx = find(@(x) strcmp(x, obj.viewer.file.tag), str);
        
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
      
      if ~isempty(obj.viewer.file) && ~isempty(obj.viewer.sequence)
        
        str  = obj.viewer.file.values('tag');
        indx = find(@(x) strcmp(x, obj.viewer.sequence.tag), str);
        
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
      
      if ~isempty(obj.viewer.file) && ~isempty(obj.viewer.signal1)
        
        str  = obj.viewer.file.signals.values('tag');
        
        indx = find(@(x) strcmp(x, obj.viewer.signal1.tag), str);
        
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
      
      if ~isempty(obj.viewer.file) && ~isempty(obj.viewer.signal2)
        
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
      
      if ~isempty(obj.viewer.signal1) && ~isempty(obj.viewer.waveform)
        
        str  = obj.viewer.file.signal1.waveforms('tag');
        indx = find(@(x) strcmp(x, obj.viewer.waveform.tag), str);
        
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
      
      if ~isempty(obj.viewer.signal1) && ~isempty(obj.viewer.amplitude)
        
        str  = obj.viewer.file.signal1.amplitudes('tag');
        indx = find(@(x) strcmp(x, obj.viewer.amplitude.tag), str);
        
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