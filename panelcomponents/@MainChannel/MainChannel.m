classdef MainChannel < PanelComponent
    %Select main panel
    properties
        ui_channel
    end
    methods
        function obj = MainChannel(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Main channel'),100);
            obj.ui_channel = mgr.add(sc_ctrl('popupmenu',[],@channel_callback,...
                'visible','off'),100);
            mgr.newline(5);
            
            function channel_callback(~,~)
                obj.show_panels(false);
                val = get(obj.ui_channel,'value');
                str = get(obj.ui_channel,'string');
                obj.gui.main_signal = obj.gui.sequence.signals.get('tag',str{val});
            end
        end
        
        function initialize(obj)
            str = obj.gui.sequence.signals.values('tag');
            val = find(cellfun(@(x) strcmp(x,obj.gui.main_signal.tag), str));
            set(obj.ui_channel,'string',str,'value',val,'visible','on');
        end
        
        function updated = update(obj)
            obj.gui.main_channel.load_data();
            updated = true;
        end
        
    end
end