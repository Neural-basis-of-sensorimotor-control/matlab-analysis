classdef SaveAmplitudeOptions < PanelComponent
  
  properties
    ui_filenbr
    ui_filename
  end
  
  
  methods
    
    function obj = SaveAmplitudeOptions(panel)
      obj@PanelComponent(panel);
    end
    
    function populate(obj,mgr)
      
      mgr.newline(20);
      obj.ui_filename = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filename_callback()),150);
      obj.ui_filenbr = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filenbr_callback()),50);
      mgr.newline(20);
      
      mgr.add(sc_ctrl('pushbutton','Save amplitudes to .dat',...
        @(~,~) obj.save_ampl_callback()), 200);
      mgr.newline(20);
      
      mgr.add(sc_ctrl('pushbutton', 'Save automated analysis to .dat', ...
        @(~,~) obj.save_automated_analysis_callback()), 200);
    end
    
    
    function initialize(obj)
      set(obj.ui_filename,'String', obj.gui.download_amplitude_filebase);
      set(obj.ui_filenbr,'String', obj.gui.download_amplitude_fileindex);
    end
    
  end
  
  methods (Access = 'protected')
    
    function save_ampl_callback(obj)
      obj.gui.download_amplitude_data();
      set(obj.ui_filenbr, 'string', obj.gui.download_amplitude_fileindex);
    end
    
    
    function save_automated_analysis_callback(obj)
      obj.gui.download_automated_amplitude_analysis();
      set(obj.ui_filenbr, 'string', obj.gui.download_amplitude_fileindex);
    end
    
    
    function filename_callback(obj)
      obj.gui.download_amplitude_filebase = get(obj.ui_filename, 'string');
    end
    
    
    function filenbr_callback(obj)
      obj.gui.download_amplitude_fileindex = str2double(get(obj.ui_filenbr, 'string'));
    end
  end
end
