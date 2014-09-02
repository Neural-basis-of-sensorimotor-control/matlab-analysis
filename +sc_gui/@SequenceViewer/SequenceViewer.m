classdef SequenceViewer < handle
    properties
        current_view
        panels    
        plot_axes
        
        plot_raw = 0
        display_digital_channels = true
        nbr_of_analog_channels = 1
        display_histogram = 1
        
        temporary_signal_tags
    end
    
    properties (SetObservable)
        update        
        has_unsaved_changes = 0
        sequence
        help
        main_channel
        pretrigger = -.1
        posttrigger = .1
        xlimits = [-.1 .1]
        set_v_to_zero_for_t             %leave empty to disable
        sweep = 1
        sweep_increment = 1
        plotmode = sc_gui.PlotModes.default
    end
    
    properties (Dependent)
        tmin
        tmax
        signals
    end
    
    properties (Constant)
        panel_width = 205;
        margin = 40
    end
    
    properties (Dependent, Abstract)
        triggertimes
    end
    
    methods (Abstract)
        add_panels(obj)
        add_channel_panel(obj)
    end

    methods (Abstract, Static)
        mode            %see ScGuiState enums
    end
    
    methods
        function obj = SequenceViewer(sequence)
            if sequence.parent.check_fdir
                obj.sequence = sequence;
                obj.panels = ScList();
                obj.plot_axes = ScList();
            else
                msgbox('Warning: file could not be found. Aborting program');
            end
        end
        
        function copy_attributes(obj, newobj)
             mco = ?sc_gui.SequenceViewer;
             plist = mco.PropertyList;
             for k=1:numel(plist)
                 p = plist(k);
                 if ~p.Dependent && ~p.Abstract && ~p.Constant
                     newobj.(p.Name) = obj.(p.Name);
                 end
             end
        end
        
        function show(obj)
            obj.current_view = gcf;
            clf(obj.current_view,'reset');
            set(obj.current_view,'ToolBar','None');
            set(obj.current_view,'Color',[0 0 0]);
            
            %Populate left hand panel
            obj.panels = ScList();
            obj.add_panels();
            
            mgr = ScLayoutManager(obj.current_view);
            for k=1:obj.panels.n
                panel = obj.panels.get(k);
                setwidth(panel,obj.panel_width);
                mgr.newline(getheight(panel));
                mgr.add(panel);
            end
            
            obj.temporary_signal_tags = {};
            for j=1:obj.plot_axes.n
                ax = obj.plot_axes.get(j);
                if isa(ax,'sc_gui.AnalogAxes')
                    obj.temporary_signal_tags(numel(obj.temporary_signal_tags)+1) = {ax.signal.tag};
                end
            end
            
            obj.plot_axes = ScList();
            
            mgr = ScLayoutManager(obj.current_view);
            mgr.leftindent = obj.panel_width + 2*obj.margin;
            
            set(obj.current_view,'ResizeFcn',@resize_figure);
            obj.update = 1;
            resize_figure();
            
            function resize_figure(~,~)
                y = getheight(obj.current_view);
                for i=1:obj.panels.n
                    y = y - getheight(obj.panels.get(i));
                    sety(obj.panels.get(i),y);
                end
                y = getheight(obj.current_view);
                axeswidth = getwidth(obj.current_view)- (obj.panel_width + 2*obj.margin);
                for i=1:obj.plot_axes.n
                    ax_ = obj.plot_axes.get(i);
                    if i==1
                        y = y - (getheight(ax_) + 10);
                    else
                        y = y - (getheight(ax_) + obj.margin);
                    end
                    sety(ax_,y);
                    if axeswidth>0,    setwidth(ax_,axeswidth);   end
                    setx(ax_, obj.panel_width + 2*obj.margin);
                end
                
                
            end
        end

        function plot_channels(obj)
            for k=1:obj.plot_axes.n
                obj.plot_axes.get(k).plotch();
            end
        end
        
        function disable_panels(obj, panel)
            index = obj.panels.indexof(panel);
            if obj.panels.n>index
                set(obj.panels.get(index+1),'visible','off');
            end
            for k=1:obj.plot_axes.n
                cla(obj.plot_axes.get(k).ax);
            end
        end
        
        function enable_panels(obj,panel)
            index = obj.panels.indexof(panel);
            if obj.panels.n>=index+1
                set(obj.panels.get(index+1),'visible','on');
            end
        end
        
        function tmin = get.tmin(obj)
            tmin = obj.sequence.tmin;
        end
        
        function tmax = get.tmax(obj)
            tmax = obj.sequence.tmax;
        end
                
        function signals = get.signals(obj)
            signals = obj.sequence.signals;
        end
        
    end
end