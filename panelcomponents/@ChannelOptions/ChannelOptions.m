classdef ChannelOptions < PanelComponent
    %Select nbr of channels etc
    properties
        ui_show_digital_channels
        ui_nbr_of_channels
    end
    
    methods
        function obj = ChannelOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_show_digital_channels = mgr.add(sc_ctrl('checkbox',...
                'Show digital channels',@(~,~) obj.show_digital_channels_callback),...
                200);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Nbr of channels'),100);
            obj.ui_nbr_of_channels = mgr.add(sc_ctrl('popupmenu',[],...
                @(~,~) obj.nbr_of_channels_callback,'visible','off'),100);
            sc_addlistener(obj.gui,'sequence',@(~,~) obj.update_nbr_of_analog_axes, ...
                obj.uihandle);
            
        end
        
        function initialize(obj)
            set(obj.ui_show_digital_channels,'value',obj.gui.show_digital_channels);
            if ~obj.gui.file.signals.n
                set(obj.ui_nbr_of_channels,'visible','off');
            else
                str = cell(obj.gui.file.signals.n,1);
                for k=1:numel(str), str(k) = {num2str(k)}; end
                obj.gui.nbr_of_analog_channels = obj.gui.analog_ch.n;
                set(obj.ui_nbr_of_channels,'string',str,'value',obj.gui.nbr_of_analog_channels,'visible',...
                    'on');
            end
        end
        
        function updated = update(obj)
            if obj.gui.file.signals.n
                obj.show_digital_channels_callback(true);
                obj.gui.nbr_of_analog_channels = get(obj.ui_nbr_of_channels,'value');
                obj.update_nbr_of_analog_axes();
                updated = true;
                set(obj.ui_nbr_of_channels,'visible','on');
            else
                set(obj.ui_nbr_of_channels,'visible','off');
                updated = false;
            end
        end
        
    end
    
    methods (Access = 'protected')
        
        function update_nbr_of_analog_axes(obj)
            for k=1:obj.gui.nbr_of_analog_channels
                if k>obj.gui.analog_ch.n
                    obj.gui.analog_subch.add(AnalogAxes(obj.gui,obj.gui.file.signals.get(k)));
                elseif  ~obj.gui.file.signals.contains(obj.gui.analog_ch.get(k).signal)
                    obj.gui.analog_ch.get(k).signal = obj.gui.file.signals.get(k);
                end
            end
            for k=obj.gui.nbr_of_analog_channels+1:obj.gui.analog_ch.n
                obj.gui.analog_subch.remove_at(obj.gui.nbr_of_analog_channels);
            end
            for k=1:obj.gui.analog_ch.n
                set(obj.gui.analog_ch.get(k),'Parent',obj.gui.plot_window);
            end
            obj.gui.resize_plot_window();
        end
        
        function show_digital_channels_callback(obj,hide_panels)
            val = get(obj.ui_show_digital_channels,'value');
            if val
                if isempty(obj.gui.digital_channels)
                    obj.gui.digital_channels = DigitalAxes(obj.gui);
                end
            else
                obj.gui.digital_channels = [];
            end
            if nargin==1 || hide_panels
                obj.show_panels(false);
            end
        end
        
        function nbr_of_channels_callback(obj)
            obj.gui.nbr_of_analog_channels = get(obj.ui_nbr_of_channels,'value');
            obj.update_nbr_of_analog_axes();
            obj.show_panels(false);
        end
    end
end

