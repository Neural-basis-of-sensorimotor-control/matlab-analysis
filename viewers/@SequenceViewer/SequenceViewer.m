classdef SequenceViewer < handle
    properties (SetObservable)
        parent
        
        current_view
        panels
        
        digital_channels
    %    analog_channels
        analog_subch
        histogram
    end
    
    properties (SetObservable)
        experiment
        file
        sequence
        
        help_text
        
        show_digital_channels = true
        show_histogram = true
        
        has_unsaved_changes
        
        main_channel
%         main_signal
%         main_axes
        
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
    
    properties (Dependent)
        plots
        tmin
        tmax
        analog_ch
        main_signal
        main_axes
    end
    
    properties (Constant)
        panel_width = 205;
        margin = 40
    end
    
    methods (Abstract)
        add_panels(obj)
    end
    
    methods (Abstract, Static)
        mode            %see ScGuiState enums
    end
    
    
    methods
        function dbg_in(obj,varargin)
            for k=1:obj.debug_indent
                fprintf('\t');
            end
            fprintf('Entering ');
            for k=1:nargin-1
                if ischar(varargin{k})
                    fprintf('%s\\',varargin{k});
                else
                    fprintf('%g\\',varargin{k});
                end
            end
            fprintf('\n');
            obj.debug_indent = obj.debug_indent + 1;
        end
        
        function dbg_out(obj,varargin)
            obj.debug_indent = obj.debug_indent - 1;
            for k=1:obj.debug_indent
                fprintf('\t');
            end
            fprintf('Exiting ');
            for k=1:nargin-1
                if ischar(varargin{k})
                    fprintf('%s\\',varargin{k});
                else
                    fprintf('%g\\',varargin{k});
                end
            end
            fprintf('\n');
        end
        
        function obj = SequenceViewer(guimanager)
            obj.setup_listeners();
            
            obj.parent = guimanager;
            obj.current_view = gcf;
            obj.analog_subch = ScCellList();
            obj.main_channel = AnalogAxes(obj);
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
            if ~isempty(obj.histogram)
                plots.add(obj.histogram);
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

    end
    
end