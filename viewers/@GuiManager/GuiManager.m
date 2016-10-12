classdef GuiManager < handle
  properties (Dependent)
    viewer
    mode
    experiment
  end

  properties (SetAccess = 'private', GetAccess = 'private')
    viewer_
  end

  methods
    function obj = GuiManager()
      obj.viewer = WaveformViewer(obj);
    end

    function show(obj)
      obj.viewer.show();
    end

    %Important: all references to previous viewer in graphics objects must be cleared
    function set.viewer(obj,new_viewer)   
  %             close all
  %             if isempty(findall(0,'type','figure'))
    obj.viewer_ = new_viewer;
  %             end
    end

    function viewer = get.viewer(obj)
      viewer = obj.viewer_;
    end

    function set.mode(obj,mode)
      %Store data for the new viewer
      sc_file_folder = obj.viewer.sc_file_folder;
      raw_data_folder = obj.viewer.raw_data_folder;
      experiment = obj.viewer.experiment;
      file = obj.viewer.file;
      sequence = obj.viewer.sequence;
      %Close all windows and destroy previous viewer
      close all
      if ~isempty(findall(0,'type','figure'))
        return
      end
      switch mode
        case ScGuiState.spike_detection
          new_viewer = WaveformViewer(obj);
        case ScGuiState.ampl_analysis
          new_viewer = AmplitudeViewer(obj);
        end
        new_viewer.set_sc_file_folder(sc_file_folder);
        new_viewer.set_raw_data_folder(raw_data_folder);
        new_viewer.set_experiment(experiment);
        new_viewer.set_file(file);
        new_viewer.set_sequence(sequence);
        obj.viewer = new_viewer;
        obj.viewer.show();
      end

      function mode = get.mode(obj)
        if isempty(obj.viewer)
          mode = [];
        else
          mode = obj.viewer.mode;
        end
      end

      function set.experiment(obj,experiment)
        obj.viewer.set_experiment(experiment);
      end
    end
  end
