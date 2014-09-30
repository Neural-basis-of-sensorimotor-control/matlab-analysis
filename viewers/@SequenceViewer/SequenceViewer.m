classdef SequenceViewer < handle
    properties (SetObservable)
        parent
        
        current_view
        panels    
        
        digital_channels
        analog_channels
        histogram
    end
    
    properties (SetObservable)
        experiment
        file
        sequence
        
        show_digital_channels = true
        show_histogram = true
        
        has_unsaved_changes
        
        main_channel
        main_signal
        main_axes

        nbr_of_analog_channels
        
        pretrigger = -.1
        posttrigger = .1
        xlimits = [-.1 .1]              %xlim value
        
        sweep = 1
        sweep_increment = 1
        plotmode = sc_gui.PlotModes.default
        
        zoom_on = 0
        pan_on = 0
        
        debug_indent = 0
    end
    
    properties (Dependent)
        plots
        tmin
        tmax
    end
    
    properties (Constant)
        panel_width = 205;
        margin = 0%40
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
            obj.parent = guimanager;
            obj.current_view = gcf;
            obj.analog_channels = ScCellList();
            obj.analog_channels.add(AnalogAxes(obj));
            obj.digital_channels = DigitalAxes(obj);
            obj.histogram = HistogramChannel(obj);
            
            obj.setup_listeners();  
        end
        
        function show(obj)
            if ishandle(obj.current_view)
                clf(obj.current_view,'reset');
            else
                obj.current_view = gcf;
            end
            set(obj.current_view,'ToolBar','None');
            set(obj.current_view,'Color',[0 0 0]);
            obj.panels = CascadeList();
            obj.add_panels();
            obj.panels.get(1).enabled = true;
            mgr = ScLayoutManager(obj.current_view);
            for k=1:obj.panels.n
                panel = obj.panels.get(k);
                setwidth(panel,obj.panel_width);
                mgr.newline(getheight(panel));
                mgr.add(panel);
            end
            mgr.trim();
            if obj.show_digital_channels
                obj.digital_channels.ax = axes;
            end
            for k=1:obj.analog_channels.n
                obj.analog_channels.get(k).ax = axes; %#ok<LAXES>
            end
            if obj.show_histogram
                obj.histogram.ax = axes;
            end
            mgr = ScLayoutManager(obj.current_view);
            for k=1:obj.plots.n
                plotaxes = obj.plots.get(k);
                mgr.newline(getheight(plotaxes));
                mgr.add(plotaxes);
            end
            
            obj.sequence = obj.sequence;
            for k=1:obj.panels.n
                obj.panels.get(k).initialize_panel();
            end
            set(obj.current_view,'ResizeFcn',@resize_figure);
            resize_figure();
            
            function resize_figure(~,~)
                y = getheight(obj.current_view);
                for i=1:obj.panels.n
                    y = y - getheight(obj.panels.get(i));
                    sety(obj.panels.get(i),y);
                end
                y = getheight(obj.current_view);
                axeswidth = getwidth(obj.current_view)- (obj.panel_width + 3*obj.margin);
                for i=1:obj.plots.n
                    ax_ = obj.plots.get(i);
                    if i==1
                        y = y - (getheight(ax_));% + 10);
                    else
                        y = y - (getheight(ax_) + obj.margin);
                    end
                    sety(ax_,y);
                    if axeswidth>0,    setwidth(ax_,axeswidth);   end
                    setx(ax_, obj.panel_width + 2*obj.margin);
                end
            end
            
        end
        
        function disable_panels(obj, panel)
            obj.dbg_in(mfilename,'disable_panels');
            index = obj.panels.indexof(panel);
            for k=index:obj.panels.n
                obj.panels.get(k).enabled = false;
            end
            for k=1:obj.plots.n
                cla(obj.plots.get(k).ax);
            end
            obj.dbg_out(mfilename,'disable_panels');
        end
        
        function enable_panels(obj,panel)
            index = obj.panels.indexof(panel);
            for k=index:obj.panels.n
                obj.panels.get(k).update_panel();
                if ~obj.panels.get(k).enabled
                    break;
                end
            end
        end
        
        function plots = get.plots(obj)
            plots = ScCellList();
            if ~isempty(obj.digital_channels)
                plots.add(obj.digital_channels);
            end
            for k=1:obj.analog_channels.n
                plots.add(obj.analog_channels.get(k));
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
        
        function copy_attributes(obj, newobj)
             mco = ?SequenceViewer;
             plist = mco.PropertyList;
             for k=1:numel(plist)
                 p = plist(k);
                 if ~p.Dependent && ~p.Abstract && ~p.Constant
                     newobj.(p.Name) = obj.(p.Name);
                 end
             end
        end
    end
    
end