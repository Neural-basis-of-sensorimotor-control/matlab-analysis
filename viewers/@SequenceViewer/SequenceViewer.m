classdef SequenceViewer < handle
    properties (SetObservable)
        parent
        
        panels
        
        btn_window
        
        digital_channels
        analog_subch
        histogram
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
    
    
    methods
        
        function obj = SequenceViewer(guimanager)
            close all
            obj.btn_window = figure;
            obj.plot_window = figure;
            
            obj.setup_listeners();
            obj.zoom_controls = ScList();
            obj.parent = guimanager;
            obj.analog_subch = ScCellList();
            obj.main_channel = AnalogAxes(obj);
            setheight(obj.main_channel,450);
            obj.digital_channels = DigitalAxes(obj);
            obj.histogram = HistogramChannel(obj);
            obj.histogram_window = figure('Color',[0 0 0]);
            set(obj.histogram,'Parent',obj.histogram_window);
            set(obj.histogram_window,'ResizeFcn',@(~,~) obj.resize_histogram_window());
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
            end
            val = obj.plot_window_pr;
        end
        function set.plot_window(obj,val)
            obj.plot_window_pr = val;
        end
        function val = get.histogram_window(obj)
            val = obj.histogram_window_pr;
        end
        function set.histogram_window(obj,val)
            if isempty(obj.histogram_window_pr) || ~ishandle(obj.histogram_window_pr)
                obj.histogram_window_pr = figure;
            end
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
                if ~isempty(obj.experiment) && ~isempty(obj.experiment.save_name)
                    [p,f,ext] = fileparts(obj.experiment.save_name);
                    if ~isempty(p)
                        obj.set_sc_file_folder(p);
                    end
                    if isdir(obj.experiment.fdir)
                        obj.set_raw_data_folder(obj.experiment.fdir);
                    end
                end
            else
                f = [];
                ext = [];
            end
            fprintf(fid,'%s\n',obj.sc_file_folder);
            fprintf(fid,'%s\n',obj.raw_data_folder);
            fprintf(fid,'%s\n',[f ext]);
            fclose(fid);
        end
    end
end