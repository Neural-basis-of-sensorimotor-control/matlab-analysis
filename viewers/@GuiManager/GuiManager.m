classdef GuiManager < handle
    properties (Dependent)
        viewer
        mode
    end
    
    properties (SetAccess = 'private', GetAccess = 'private')
        viewer_
    end
    
    methods
        function obj = GuiManager()
     %       obj.viewer = WaveformViewer();
        end
        
        function show(obj)
            obj.viewer.show();
        end
        
        %Important: must clear all referneces to previous viewer
        function set.viewer(obj,new_viewer)
            if ~isempty(obj.viewer)
                obj.viewer.copy_attributes(new_viewer);
            end
            obj.viewer_ = new_viewer;
            new_viewer.parent = obj;
        end
        
        function viewer = get.viewer(obj)
            viewer = obj.viewer_;
        end
        
        function set.mode(obj,mode)
            switch mode
                case ScGuiState.spike_detection
                    newobj = WaveformViewer();
                case ScGuiState.ampl_analysis
                    newobj = AmplitudeViewer();
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
    end
end