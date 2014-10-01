classdef FilterOptions < PanelComponent
    properties
        ui_smoothing_width
        ui_artifact_width
        ui_artifact_nbr_of_samples
    end
    methods
        function obj = FilterOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            obj.dbg_in(mfilename,'populate');
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
            mgr.add(sc_ctrl('text','Moving avg width'),100);
            obj.ui_artifact_nbr_of_samples = mgr.add(sc_ctrl('edit',[],@(~,~) obj.artifact_samples_callback,'ToolTipString',...
                'Nbr of samples for moving average (empty = all)'),50);
            mgr.add(sc_ctrl('text','samples'),50);
            
            sc_addlistener(obj.gui,'main_channel',@(~,~) obj.main_channel.listener,obj.uihandle);
            obj.dbg_out(mfilename,'populate');
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
        end
        
        function smoothing_width_callback(obj)
            obj.gui.main_signal.filter.smoothing_width = str2double(get(obj.ui_smoothing_width,'string'));
            obj.show_panels(false);
        end
        
        function artifact_width_callback(obj)
            obj.gui.main_signal.filter.artifact_width = str2double(get(obj.ui_artifact_width,'string'));
            obj.show_panels(false);
        end
        
        
        function artifact_samples_callback(obj)
          msgbox('to be implemented');
            obj.show_panels(false);
        end

    end
end