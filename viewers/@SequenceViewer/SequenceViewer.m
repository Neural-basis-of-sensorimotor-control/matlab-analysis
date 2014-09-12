classdef SequenceViewer < handle
    properties
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
        
        main_signal
        main_channel

        nbr_of_analog_channels
    end
    
    properties (Dependent)
        plots
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
        function obj = SequenceViewer()
            obj.plots = ScCellList();
            obj.setup_listeners();  
        end
        
        function show(obj)
            obj.current_view = gcf;
            clf(obj.current_view,'reset');
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
        
        function disable_panels(obj, panel)
            index = obj.panels.indexof(panel);
            if obj.panels.n>index
                obj.panels.get(index+1).enabled = false;
            end
            for k=1:obj.plots.n
                cla(obj.plots.get(k).ax);
            end
        end
        
        function enable_panels(obj,panel)
            index = obj.panels.indexof(panel);
            if obj.panels.n>=index+1
                obj.panels.get(index+1).enabled = true;
            end
        end
    end
    
end