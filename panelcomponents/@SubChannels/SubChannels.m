classdef SubChannels < PanelComponent
    properties
        ui_extra_channels
    end
    methods
        function obj = SubChannels(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            ui_extra_channels = ScList();
            for k=2:obj.nbr_of_analog_channels
                mgr.newline(20);
                mgr.add(sc_ctrl('text',sprintf('Channel #%i',k)),100);
                ui_channel = mgr.add(sc_ctrl('popupmenu',...
                    [],@(~,~) obj.show_panels(false),'visible','off'),100);
                mgr.newline(5);
                ui_extra_channels.add(ui_channel);
            end

        end
        
        function initialize(obj)
            for i=1:ui_extra_channels.n
                val = get(ui_extra_channels.get(i),'value');
                str = get(ui_extra_channels.get(i),'string');
                signal = obj.sequence.signals.get('tag',str{val});
                obj.plot_axes.add(sc_gui.AnalogAxes(obj,signal));
            end
        end
        
    end
end