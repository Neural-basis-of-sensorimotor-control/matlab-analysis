classdef FilterOptions < PanelComponent
    properties
        ui_smoothing_width
        ui_artifact_width
    end
    methods
        function obj = FilterOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Smoothing width'),100);
            obj.ui_smoothing_width = mgr.add(sc_ctrl('edit',[],@smoothing_width_callback,...
                'ToolTipString','Smoothing width in bins (1 = off))'),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Artifact width'),100);
            obj.ui_artifact_width = mgr.add(sc_ctrl('edit',[],@artifact_width_callback,'ToolTipString',...
                'Artifact width in bins (0 = off))'),100);
            
            sc_addlistener(obj.gui,'main_signal',@(~,~) obj.main_signal_listener,obj.uihandle);
            
        end
        
        function initialize(obj)
            obj.main_signal_listener();
        end
        
        function main_signal_listener(obj)
            set(obj.ui_artifact_width,'string',obj.main_signal.filter.artifact_width);
            set(obj.ui_smoothing_width,'string',obj.main_signal.filter.smoothing_width);
        end
        
        function smoothing_width_callback(~,~)
            obj.main_signal.filter.smoothing_width = str2double(get(obj.ui_smoothing_width,'string'));
            obj.show_panels(false);
        end
        
        function artifact_width_callback(~,~)
            obj.main_signal.filter.artifact_width = str2double(get(obj.ui_artifact_width,'string'));
            obj.show_panels(false);
        end
    end
end