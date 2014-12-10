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
            ch = get(obj.gui.plot_window,'children');
            for k=1:numel(ch)
                delete(ch(k));
            end
            for k=1:obj.gui.plots.n
                obj.gui.plots.get(k).ax = axes('Parent',obj.gui.plot_window); 
            end
            obj.gui.resize_plot_window();
            if obj.gui.file.signals.n
                set(obj.ui_nbr_of_channels,'visible','on');
                updated = true;
            else
                set(obj.ui_nbr_of_channels,'visible','off');
                updated = false;
            end
        end
        
    end
    
    methods (Access = 'protected')
        
        function update_nbr_of_analog_axes(obj)
            signals = obj.gui.file.signals;
            analog_subch = obj.gui.analog_subch;
            nbr_of_analog_subch = obj.gui.nbr_of_analog_channels-1;
            for k=1:nbr_of_analog_subch
                if k>obj.gui.analog_subch.n
                    %Add extra analog channel
                    analog_subch.add(AnalogAxes(obj.gui,signals.get(k)));
                else
                    old_signal = analog_subch.get(k).signal;
                    if  ~signals.contains(old_signal)
                        %Channel does not belong to this file, add an accurate
                        %one
                        if sc_contains(signals.values('tag'),old_signal.tag)
                            %Add channel with same tag string
                            ch = analog_subch.get(k); 
                            ch.signal = signals.get('tag',old_signal.tag);
                            ch.clear_data();
                        else
                            %Add arbitrary channel
                            analog_subch.add(AnalogAxes(obj.gui,signals.get(k)));
                        end
                    else
                        %Add arbitrary channel
                        analog_subch.add(AnalogAxes(obj.gui,signals.get(k)));
                    end
                end
            end
            %Remove superfluous channels
            while nbr_of_analog_subch<analog_subch.n
                ax = analog_subch.get(analog_subch.n);
                if ishandle(ax)
                    delete(ax);
                end
                analog_subch.remove_at(analog_subch.n);
            end
            %Assign to correct parent figure
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
                    set(obj.gui.digital_channels.ax,'Parent',obj.gui.plot_window);
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

