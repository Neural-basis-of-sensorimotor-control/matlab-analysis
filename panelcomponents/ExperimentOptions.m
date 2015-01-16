classdef ExperimentOptions < PanelComponent
    properties
        ui_experiment
        ui_file
        ui_sequence
    end
    
    methods
        function obj = ExperimentOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj, mgr)
            
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Experiment:'),100);
            obj.ui_experiment = mgr.add(sc_ctrl('text',[]),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','File:'),100);
            obj.ui_file = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.file_callback,...
                'visible','off'),100);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Sequence:'),100);
            obj.ui_sequence = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.sequence_callback,...
                'visible','off'),100);
            
            sc_addlistener(obj.gui,'experiment',@(src,ext) obj.experiment_listener,obj.uihandle);
            sc_addlistener(obj.gui,'file',@(src,ext) obj.file_listener,obj.uihandle);
            sc_addlistener(obj.gui,'sequence',@(src,ext) obj.sequence_listener,obj.uihandle);
            
        end
        
        function initialize(obj)
            obj.experiment_listener();
            obj.file_listener();
            obj.sequence_listener();
        end
        
    end
    
    methods (Access = 'protected')
        
        function experiment_listener(obj,~,~)
            if ~isempty(obj.gui.experiment)
                [~,f] = fileparts(obj.gui.experiment.save_name);
                set(obj.ui_experiment,'string',f,'visible','on');
            else
                set(obj.ui_experiment,'string',[],'visible','off');
            end
        end
        
        function file_listener(obj,~,~)
            if ~isempty(obj.gui.file)
                str = obj.gui.experiment.values('tag');
                val = find(cellfun(@(x) strcmp(x,obj.gui.file.tag),str));
                set(obj.ui_file,'string',str,'value',val,'visible','on');
            else
                set(obj.ui_file,'visible','off');
            end
        end
        
        function sequence_listener(obj,~,~)
            if ~isempty(obj.gui.sequence)
                str = obj.gui.file.values('tag');
                val = find(cellfun(@(x) strcmp(x,obj.gui.sequence.tag),str));
                set(obj.ui_sequence,'string',str,'value',val,'visible','on');
            else
                set(obj.ui_sequence,'visible','off');
            end
        end
        
        function file_callback(obj)
            str = get(obj.ui_file,'string');
            val = get(obj.ui_file,'value');
            obj.gui.set_file(obj.gui.experiment.get('tag',str{val}));
            obj.show_panels(false);
            if obj.gui.automatic_update_on
                obj.panel.update_panel;
            end
        end
        
        function sequence_callback(obj)
            str = get(obj.ui_sequence,'string');
            val = get(obj.ui_sequence,'value');
            obj.gui.set_sequence(obj.gui.file.get('tag',str{val}));
            obj.show_panels(false);
            if obj.gui.automatic_update_on
                obj.panel.update_panel;
            end
        end
    end
    
end