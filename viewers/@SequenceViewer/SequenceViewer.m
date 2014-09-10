classdef SequenceViewer < handle
    properties
        current_view
        panels    
        plots
    end
    
    properties (SetObservable)
        experiment
        file
        sequence
        
        show_digital_channels = true
        show_histogram = true
        
    %    text
    end
    
    properties (SetObservable, GetObservable)
        nbr_of_analog_channels
    end
    
    properties (Constant)
        panel_width = 200
    end
    
    methods
        function obj = SequenceViewer()
            obj.plots = ScList();
            obj.setup_listeners();  
        end
        
        function show(obj)
            obj.current_view = gcf;
            clf(obj.current_view,'reset');
            set(obj.current_view,'ToolBar','None');
            set(obj.current_view,'Color',[0 0 0]);
            obj.panels = CascadeList();
            panel = InfoPanel(obj);
            panel.layout();
            obj.panels.add(panel);
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
            
            
        end
        
        %Set all below input panel to invisible
        function disable_panels(obj, panel)
            index = obj.panels.indexof(panel);
            if obj.panels.n>index
                set(obj.panels.get(index+1),'visible','off');
            end
            for k=1:obj.plots.n
                cla(obj.plots.get(k).ax);
            end
        end
    end
    
end