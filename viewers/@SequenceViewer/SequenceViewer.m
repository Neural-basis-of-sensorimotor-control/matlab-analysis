classdef SequenceViewer < handle
    methods (Static)
        function str = version_str()
            str = '1.0.12';
        end
    end
    properties (SetObservable)
        parent
        
        panels
        
        btn_window
        
        digital_channels
        analog_subch
        histogram
        rmwf
    end
    
    properties (SetObservable, SetAccess = 'protected')
        experiment
        file
        sequence
        sc_file_folder
        raw_data_folder
    end
    properties (SetObservable)
        help_text
        
        has_unsaved_changes
        
        main_channel
        
        nbr_of_analog_channels
        
        pretrigger = -.1
        posttrigger = .1
        xlimits = [-.1 .1]              %xlim value
        
        sweep = 1
        sweep_increment = 1
        plotmode = PlotModes.default
        
        zoom_on = 0
        pan_on = 0
        
        debug_indent = 0
    end
    
    properties
        zoom_controls
        filepath
        reset_btn
    end
    
    properties (Dependent)
        plots
        tmin
        tmax
        analog_ch
        main_signal
        main_axes
        show_digital_channels
        show_histogram
        
        plot_window
        histogram_window
        rasterplot_window
    end
    
    properties
        plot_window_pr
        histogram_window_pr
        rasterplot_window_pr
    end
    
    properties (Constant)
        panel_width = 205;
        margin = 40
    end
    
    methods (Abstract)
        add_constant_panels(obj)
        add_dynamic_panels(obj)
        delete_dynamic_panels(obj)
    end
    
    methods (Abstract, Static)
        mode            %see ScGuiState enums
    end
    
    methods (Access = 'protected')
        has_unsaved_changes_listener(obj)
    end
    methods
        function obj = SequenceViewer(guimanager)
            %close(findobj('Tag','Main Figure'));
            close all
            obj.btn_window = figure('Tag','Main Figure');
            obj.plot_window = figure;
            
            obj.setup_listeners();
            obj.zoom_controls = ScList();
            obj.parent = guimanager;
            obj.analog_subch = ScCellList();
            obj.main_channel = AnalogAxes(obj);
            setheight(obj.main_channel,450);
            obj.digital_channels = DigitalAxes(obj);
            obj.histogram = HistogramChannel(obj);
        end
        
        function analog_ch = get.analog_ch(obj)
            analog_ch = ScCellList();
            analog_ch.add(obj.main_channel);
            for k=1:obj.analog_subch.n
                analog_ch.add(obj.analog_subch.get(k));
            end
        end
        
        function plots = get.plots(obj)
            plots = ScCellList();
            if ~isempty(obj.digital_channels)
                plots.add(obj.digital_channels);
            end
            for k=1:obj.analog_ch.n
                plots.add(obj.analog_ch.get(k));
            end
        end
        
        function tmin = get.tmin(obj)
            tmin = obj.sequence.tmin;
        end
        
        function tmax = get.tmax(obj)
            tmax = obj.sequence.tmax;
        end
        
        function main_signal = get.main_signal(obj)
            main_signal = obj.main_channel.signal;
        end
        
        function main_axes = get.main_axes(obj)
            main_axes = obj.main_channel.ax;
        end
        function val = get.show_digital_channels(obj)
            val = ~isempty(obj.digital_channels);
        end
        function val = get.show_histogram(obj)
            val = ~isempty(obj.histogram);
        end
        function val = get.plot_window(obj)   
            if isempty(obj.plot_window_pr) || ~ishandle(obj.plot_window_pr)
                obj.plot_window_pr = figure;
                clf(obj.plot_window_pr,'reset');
                set(obj.plot_window_pr,'ToolBar','None','MenuBar','none');
                set(obj.plot_window_pr,'Color',[0 0 0]);
                set(obj.plot_window_pr,'ResizeFcn',@(~,~) obj.resize_plot_window());
            end
            val = obj.plot_window_pr;
        end
        function set.plot_window(obj,val)
            obj.plot_window_pr = val;
        end
        function val = get.histogram_window(obj)
            if isempty(obj.histogram_window_pr) || ~ishandle(obj.histogram_window_pr)
                obj.histogram_window_pr = figure('Color',[0 0 0],...
                    'ResizeFcn',@(~,~) obj.resize_histogram_window);
                if ~isempty(obj.histogram)
                    set(obj.histogram,'Parent',obj.histogram_window_pr);
                    if isempty(obj.histogram.ax) || ~ishandle(obj.histogram.ax)
                        obj.histogram.ax = axes;
                    end
                end
            end
            val = obj.histogram_window_pr;
        end
        function set.histogram_window(obj,val)
            obj.histogram_window_pr = val;
        end
        function val = get.rasterplot_window(obj)
            if isempty(obj.rasterplot_window_pr) || ~ishandle(obj.rasterplot_window_pr)
                obj.rasterplot_window_pr = figure;
            end
            val = obj.rasterplot_window_pr;
        end
        function set.rasterplot_window(obj,val)
            obj.rasterplot_window_pr = val;
        end
        function delete(obj)
            fid = fopen('sc_config.txt','w');
            if ~isempty(obj.experiment)
                fprintf(fid,'%s\n',obj.experiment.sc_dir);
                fprintf(fid,'%s\n',obj.experiment.fdir);
                fprintf(fid,'%s\n',obj.experiment.save_name);
            else
                fprintf(fid,'%s\n',obj.sc_file_folder);
                fprintf(fid,'%s\n',obj.raw_data_folder);
                fprintf(fid,'%s\n','');
            end
            fclose(fid);
        end
    end
end
