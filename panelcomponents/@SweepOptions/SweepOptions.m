classdef SweepOptions < PanelComponent
    properties
        ui_pretrigger
        ui_posttrigger
        ui_sweep
        ui_increment
        ui_previous
        ui_next
    end
    
    methods
        function obj = SweepOptions(panel)
            obj@PanelComponent(panel);
            sc_addlistener(obj.gui,'sweep',@(~,~) obj.sweep_listener,obj.uihandle);
            sc_addlistener(obj.gui,'sweep_increment',@(~,~) obj.increment_listener,obj.uihandle);
            sc_addlistener(obj.gui,'pretrigger',@(~,~) obj.pretrigger_listener,obj.uihandle);
            sc_addlistener(obj.gui,'posttrigger',@(~,~) obj.posttrigger_listener,obj.uihandle);
            sc_addlistener(obj.gui,'plotmode',@(~,~) obj.plotmode_listener,obj.uihandle);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Pretrigger'),100);
            obj.ui_pretrigger = mgr.add(sc_ctrl('edit',[],@(~,~) obj.btn_callbacks('pretrigger')),80);
            mgr.add(sc_ctrl('text','(s)'),20);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Postrigger'),100);
            obj.ui_posttrigger = mgr.add(sc_ctrl('edit',[],@(~,~) obj.btn_callbacks('posttrigger')),80);
            mgr.add(sc_ctrl('text','(s)'),20);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Sweep'),100);
            obj.ui_sweep = mgr.add(sc_ctrl('edit',[],@(~,~) obj.btn_callbacks('sweep')),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Increment'),100);
            obj.ui_increment = mgr.add(sc_ctrl('edit',[],@(~,~) obj.btn_callbacks('increment')),100);
            mgr.newline(20);
            obj.ui_previous = mgr.add(sc_ctrl('pushbutton','Previous',@(~,~) obj.btn_callbacks('previous')),100);

            obj.ui_next = mgr.add(sc_ctrl('pushbutton','Next',@(~,~) obj.btn_callbacks('next')),100);
        end
        
        function initialize(obj)
            obj.pretrigger_listener();
            obj.posttrigger_listener();
            obj.sweep_listener();
            obj.increment_listener();
            obj.plotmode_listener();
        end
        
    end
    
    methods (Access = 'protected')
        function pretrigger_listener(obj)
            set(obj.ui_pretrigger,'string',obj.gui.pretrigger);
        end
        function posttrigger_listener(obj)
            set(obj.ui_posttrigger,'string',obj.gui.posttrigger);
        end
        function sweep_listener(obj)
            sweep = obj.gui.sweep;
            if size(sweep,1)>1, sweep = sweep'; end
            set(obj.ui_sweep,'string',num2str(sweep));
        end
        function increment_listener(obj)
            set(obj.ui_increment,'string',obj.gui.sweep_increment);
        end
        
        function btn_callbacks(obj,btn_id)
            switch btn_id
                case 'pretrigger'
                    obj.gui.pretrigger = str2double(get(obj.ui_pretrigger,'string'));
                case 'posttrigger'
                    obj.gui.posttrigger = str2double(get(obj.ui_posttrigger,'string'));
                case 'sweep'
                    obj.gui.set_sweep(str2num(get(obj.ui_sweep,'string')));
                    obj.gui.sweep_increment = numel(obj.gui.sweep);
                case 'increment'
                    obj.gui.sweep_increment = str2double(get(obj.ui_increment,'string'));
                case 'next'
                    obj.gui.set_sweep(obj.gui.sweep + obj.gui.sweep_increment);
                case 'previous'
                    obj.gui.set_sweep(obj.gui.sweep - obj.gui.sweep_increment);
                otherwise
                    warning(['id ' btn_id ' does not exist'])
            end
        end
        
        function plotmode_listener(obj)
            if obj.gui.plotmode == PlotModes.plot_all || ...
                    obj.gui.plotmode == PlotModes.plot_avg_std_all
                set(obj.ui_sweep,'enable','off');
                set(obj.ui_increment,'enable','off');
                set(obj.ui_next,'enable','off');
                set(obj.ui_previous,'enable','off');
            else
                set(obj.ui_sweep,'enable','on');
                set(obj.ui_increment,'enable','on');
                set(obj.ui_next,'enable','on');
                set(obj.ui_previous,'enable','on');
            end
        end
    end
    
end