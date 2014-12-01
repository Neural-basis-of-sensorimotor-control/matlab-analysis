classdef FilterOptions < PanelComponent
    properties
        ui_smoothing_width
        ui_artifact_width
        ui_artifact_nbr_of_samples
        ui_scale_factor
    end
    methods
        function obj = FilterOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Smoothing width'),100);
            obj.ui_smoothing_width = mgr.add(sc_ctrl('edit',[],@(~,~) obj.smoothing_width_callback,...
                'ToolTipString','Smoothing width in bins (1 = off))'),50);
            mgr.add(sc_ctrl('text','bins'),50);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Artifact width'),100);
            obj.ui_artifact_width = mgr.add(sc_ctrl('edit',[],@(~,~) obj.artifact_width_callback,'ToolTipString',...
                'Artifact width in bins (0 = off))'),50);
            mgr.add(sc_ctrl('text','bins'),50);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Scale factor'),100);
            obj.ui_scale_factor = mgr.add(sc_ctrl('edit',[],@(~,~) obj.scale_factor_callback),100);
            
            sc_addlistener(obj.gui,'main_channel',@(~,~) obj.main_channel.listener,obj.uihandle);

        end
        
        function initialize(obj)
            obj.main_signal_listener();
        end
    end
    
    methods (Access = 'protected')
        function main_channel_listener(obj)
            sc_addlistener(obj.gui.main_channel,'signal',@(~,~) obj.main_signal_listener,obj.uihandle);
        end
        
        function main_signal_listener(obj)
            set(obj.ui_artifact_width,'string',obj.gui.main_signal.filter.artifact_width);
            set(obj.ui_smoothing_width,'string',obj.gui.main_signal.filter.smoothing_width);
            set(obj.ui_scale_factor,'string',obj.gui.main_signal.filter.scale_factor);
        end
        
        function smoothing_width_callback(obj)
            smoothing_width = round(str2double(get(obj.ui_smoothing_width,'string')));
            if ~isfinite(smoothing_width) || ~smoothing_width
                msgbox('Smoothing width has to be a positive integer. 1 = off');
                set(obj.ui_smoothing_width,'string',obj.gui.main_signal.filter.smoothing_width);
            else
                obj.gui.main_signal.filter.smoothing_width = str2double(get(obj.ui_smoothing_width,'string'));
                obj.gui.has_unsaved_changes = true;
                obj.show_panels(false);
            end
        end
        
        function artifact_width_callback(obj)
            width = round(str2double(get(obj.ui_artifact_width,'string')));
            if ~isfinite(width) || width < 0
                 msgbox('Artifact width has to be a non-negative integer. 0 = off');
                set(obj.ui_artifact_width,'string',obj.gui.main_signal.filter.artifact_width);
            else
                obj.gui.main_signal.filter.artifact_width = width;
                obj.gui.has_unsaved_changes = true;
                obj.show_panels(false);
            end
        end
        
        function scale_factor_callback(obj)
            scale_factor = str2double(get(obj.ui_scale_factor,'string'));
            if ~isfinite(scale_factor)
                msgbox('Scale factor has to be a finite number. 1 = off');
                set(obj.ui_scale_factor,'string',obj.gui.main_signal.filter.scale_factor);
            else
                obj.gui.main_signal.filter.scale_factor = scale_factor;
                obj.gui.has_unsaved_changes = true;
                obj.show_panels(false);
            end
        end

    end
end