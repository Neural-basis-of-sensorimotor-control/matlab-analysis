classdef OffsetAtTime < PanelComponent
    properties
        ui_value
    end
    
    methods
        function obj = OffsetAtTime(panel)
            obj@PanelComponent(panel);
            sc_addlistener(obj.gui,'main_channel',@(~,~) obj.main_channel_listener, panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Set v = for t = '),100);
            obj.ui_value = mgr.add(sc_ctrl('edit',[],@(~,~) obj.value_callback),80);
            mgr.add(sc_ctrl('text','(s)'),20);
        end
        
        function initialize(obj)
            obj.main_channel_listener();
        end
        
    end
    
    methods (Access = 'private')
        function main_channel_listener(obj)
            if ~isempty(obj.gui.main_channel)
                sc_addlistener(obj.gui.main_channel,'v_equals_zero_for_t',@(~,~) obj.offset_listener, obj.uihandle);
                obj.offset_listener();
            end
        end
        
        function offset_listener(obj)
            if isempty(obj.gui.main_channel.v_equals_zero_for_t) || ~isfinite(obj.gui.main_channel.v_equals_zero_for_t)
                set(obj.ui_value,'string',[]);
            else
                set(obj.ui_value,'string',obj.gui.main_channel.v_equals_zero_for_t);
            end
        end
        
        function value_callback(obj)
            val = str2double(get(obj.ui_value,'string'));
            if isnumeric(val)
                obj.gui.main_channel.v_equals_zero_for_t = val;
            else
                obj.gui.main_channel.v_equals_zero_for_t = [];
            end
            obj.gui.plot_channels();
        end
    end
    
    
end