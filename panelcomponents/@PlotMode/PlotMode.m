classdef PlotMode < PanelComponent
    properties
        ui_plot_mode
    end
    
    methods
        function obj = PlotMode(panel)
            obj@PanelComponent(panel);
            sc_addlistener(obj.gui,'plotmode',@(~,~) plotmode_listener,obj.uihandle);
            
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Plot mode'),100);
            [~,str_] = enumeration('sc_gui.PlotModes');
            obj.ui_plot_mode = mgr.add(sc_ctrl('popupmenu',str_,@(~,~) obj.plot_mode_callback),100);
        end
        
        function initialize(obj)
            [~,str_] = enumeration('sc_gui.PlotModes');
            val = find(enumeration('sc_gui.PlotModes') == obj.gui.plot_mode);
            set(obj.ui_plot_mode,'string',str_,'value',val);
        end
        
    end
    
    methods (Access = 'protected')
        function plot_mode_callback(obj)
            str = get(obj.ui_plot_mode,'string');
            val = get(obj.ui_plot_mode,'value');
            [enum,enum_str] = enumeration('sc_gui.PlotModes');
            ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
            obj.gui.plotmode = enum(ind);
        end
        
        function plotmode_listener(obj)
            for k=1:obj.gui.plot_axes.n
                cla(obj.gui.plot_axes.get(k).ax);
            end
        end
    end
    
end