classdef PlotOptions < PanelComponent
    properties
        ui_plot_raw
        ui_plot_waveform
    end
    methods
        function obj = PlotOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_plot_raw = mgr.add(sc_ctrl('checkbox','Plot raw data',@plot_raw_callback,...
                'value',obj.main_channel.plot_raw),200);
            mgr.newline(5);
            mgr.newline(20);
            obj.ui_plot_waveforms = mgr.add(sc_ctrl('checkbox','Waveforms',@plot_waveforms_callback,...
                'value',obj.main_channel.plot_waveforms),200);
            mgr.newline(5);
            
            function plot_raw_callback(~,~)
                obj.main_channel.plot_raw = get(obj.ui_plot_raw,'value');
            end
            
            function plot_waveforms_callback(~,~)
                obj.main_channel.plot_waveforms = get(obj.ui_plot_waveforms,'value');
            end
        end
    end
end