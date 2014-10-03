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
        
        %Important: must clear all referneces to previous viewer
        function set.viewer(obj,new_viewer)
            if ~isempty(obj.viewer)
                obj.viewer.copy_attributes(new_viewer);
                for k=1:new_viewer.plots.n
                    new_viewer.plots.get(k).gui = obj.viewer.plots.get(k).gui;
                end
            end
            obj.viewer_ = new_viewer;
        end
        
        function viewer = get.viewer(obj)
            viewer = obj.viewer_;
        end
        
        function set.mode(obj,mode)
            switch mode
                case ScGuiState.spike_detection
                    newobj = WaveformViewer(obj);
                case ScGuiState.ampl_analysis
                    newobj = AmplitudeViewer(obj);
            end
            obj.viewer = newobj;
        end
        
        function mode = get.mode(obj)
            if isempty(obj.viewer)
                mode = [];
            else
                mode = obj.viewer.mode;
            end
        end
        
        function set.experiment(obj,experiment)
            obj.viewer.experiment = experiment;
        end
    end
end