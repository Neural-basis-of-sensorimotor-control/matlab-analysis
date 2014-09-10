classdef ChannelOptions < GuiComponent & UiWrapper
    properties
        ui_show_digital_channels
        ui_nbr_of_channels
        ui_show_histogram
    end
    
    methods
        function obj = ChannelOptions(gui,panel)
            obj@GuiComponent(gui);
            obj@UiWrapper(panel);
        end
        
        function populate_panel(obj,mgr)
            mgr.newline(20);
            obj.ui_show_digital_channels = mgr.add(sc_ctrl('checkbox',...
                'Show digital channels',@show_digital_channels_callback),...
                200);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Nbr of channels'),100);
            obj.ui_nbr_of_channels = mgr.add(sc_ctrl('popupmenu',[],...
                @nbr_of_channels_callback,'visible','off'),100);
            mgr.newline(20);
            obj.ui_show_histogram = mgr.add(sc_ctrl('checkbox',...
                'Show histogram',@show_histogram_callback),...
                200);
            sc_addlistener(obj.gui,'sequence',@(~,~) obj.sequence_listener, ...
                obj.uihandle);
            
            function show_digital_channels_callback(~,~)
                obj.gui.show_digital_channels = get(obj.ui_show_digital_channels,'value');
            end
            
            function nbr_of_channels_callback(~,~)
                obj.gui.nbr_of_analog_channels = get(obj.ui_nbr_of_channels,'value');
            end
            
            function show_histogram_callback(~,~)
                obj.gui.show_histogram = get(obj.ui_show_histogram,'value');
            end
        end
        
        function initialize_panel(obj)
            set(obj.ui_show_digital_channels,'value',obj.gui.show_digital_channels);
            obj.sequence_listener();
            set(obj.ui_show_histogram,'value',obj.gui.show_histogram);
        end
        
        function updated = update_panel(obj)
            obj.show_digital_channels = get(obj.ui_show_digital_channels,'value');
            obj.nbr_of_analog_channels = get(obj.ui_nbr_of_channels,'value');
            obj.show_histogram = get(obj.ui_show_histogram,'value');
            updated = true;
        end
        
    end
    
    methods (Access = 'private')
        function sequence_listener(obj)
            str = cell(obj.gui.sequence.signals.n,1);
            for k=1:numel(str), str(k) = {num2str(k)}; end
            val = get(obj.ui_nbr_of_channels,'value');
            if val>numel(str),    val = 1;  end
            set(obj.ui_nbr_of_channels,'string',str,...
                'value',obj.gui.nbr_of_analog_channels,...
                'value',val,'visible','on');
        end
    end
end
            
        