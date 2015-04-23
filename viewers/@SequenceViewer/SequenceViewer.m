classdef SequenceViewer < handle   
    properties (Dependent, Abstract)
        triggertimes
        nbr_of_constant_panels
    end
    methods (Abstract, Static)
        mode            %see ScGuiState enums
    end
    methods (Abstract)
        %Add panels that will never be deleted during usage
        add_constant_panels(obj)
        %Add panels that can be deleted and reconstructed when data has
        %changed
        add_dynamic_panels(obj)
        %Delete deletable panels
        delete_dynamic_panels(obj)
    end
    methods (Static)
        function str = version_str()
            str = 'hannes-adq branch 2015-Apr-24';
        end
    end
    properties (SetObservable)
        parent              %GuiManager
        
        panels              %CascadeList
        
        btn_window          %Figure
        
        digital_channels    %DigitalAxes
        analog_subch        %ScCellList
        histogram           %HistogramChannel
        rmwf                %ScRemoveWaveform
    end
    
    properties (SetObservable, SetAccess = 'protected')
        experiment          %ScExperiment
        file                %ScFile
        sequence            %ScSequence
        sc_file_folder      %char array
        raw_data_folder     %char array
    end
    properties (SetAccess = 'private', GetAccess = 'private')
        deletechannel
    end
    properties (SetObservable)
        help_text           %char array
        
        has_unsaved_changes
        
        main_channel        %AnalogAxes
        
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
        
        automatic_update_on = true
    end
    
    properties
        zoom_controls       %uicontrol array
        filepath            %char array
        reset_btn           %uicontrol
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
        plot_window_pr          %Figure
        histogram_window_pr     %Figure
        rasterplot_window_pr    %Figure
    end
    
    properties (Constant)
        panel_width = 205;
        margin = 40
    end 
    methods (Access = 'protected')
        has_unsaved_changes_listener(obj)
    end
    methods
        %obj.create_channels must be called in inheriting class right
        %after calling SequenceViewer constructor
        function obj = SequenceViewer(guimanager)
            obj.btn_window = figure('Tag','Main Figure');
            obj.plot_window = figure;
            obj.setup_listeners();
            obj.zoom_controls = ScList();
            obj.parent = guimanager;
        end
        
        %override to use customized channel classes
        function create_channels(obj)
            obj.analog_subch = ScCellList();
            obj.main_channel = AnalogAxes(obj);
            setheight(obj.main_channel,450);
            obj.digital_channels = DigitalAxes(obj);
            obj.histogram = HistogramChannel(obj);
        end
        
        function add_reset_panel(obj)
            obj.panels.add(UpdatePanel(obj));
            obj.panels.add(ModePanel(obj));
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
                set(obj.plot_window_pr,'SizeChangedFcn',@(~,~) obj.resize_plot_window());
            end
            val = obj.plot_window_pr;
        end
        function set.plot_window(obj,val)
            obj.plot_window_pr = val;
        end
        function val = get.histogram_window(obj)
            if isempty(obj.histogram_window_pr) || ~ishandle(obj.histogram_window_pr)
                obj.histogram_window_pr = figure('Color',[0 0 0],...
                    'SizeChangedFcn',@(~,~) obj.resize_histogram_window);
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
