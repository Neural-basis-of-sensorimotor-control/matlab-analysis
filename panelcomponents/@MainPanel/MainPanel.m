classdef MainPanel < PanelComponent
    properties
        ui_experiment
        ui_file
        ui_sequence
    end
    
    methods
        function obj = MainPanel(panel)
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
    
    methods (Access = 'private')
        
        function experiment_listener(obj,~,~)
            if ~isempty(obj.gui.experiment)
                set(obj.ui_experiment,'string',obj.gui.experiment.save_name,'visible','on');
                if obj.gui.experiment.n
                    set(obj.ui_file,'string',obj.gui.experiment.values('tag'),'visible','on');
                else
                    set(obj.ui_file,'visible','off');
                end
            else
                set(obj.ui_experiment,'string',[]);
                set(obj.ui_file,'visible','off');
            end
            
        end

        function file_listener(obj,~,~)
            if ~isempty(obj.gui.file)
                index = find(cellfun(@(x) strcmp(x,obj.gui.file.tag),obj.gui.experiment.values('tag')));
                set(obj.ui_file,'value',index,'visible','on');
                if obj.gui.file.n
                    set(obj.ui_sequence,'string',obj.gui.file.values('tag'),'visible','on');
                else
                    set(obj.ui_sequence,'visible','off');
                end
            else 
                set(obj.ui_file,'visible','off');
                set(obj.ui_sequence,'visible','off');
            end
        end
        
        function sequence_listener(obj,~,~)
            if ~isempty(obj.gui.sequence)
                index = find(cellfun(@(x) strcmp(x,obj.gui.sequence.tag),obj.gui.file.values('tag')));
                set(obj.ui_sequence,'value',index,'visible','on');
            else 
                set(obj.ui_sequence,'visible','off');
            end
        end
        
        function file_callback(obj)
          %  obj.gui.disable_panels(obj);
            obj.show_panels(false);
            str = get(obj.ui_file,'string');
            val = get(obj.ui_file,'value');
            obj.gui.file = obj.gui.experiment.get('tag',str{val});
        end
        
        function sequence_callback(obj)            
        %    obj.gui.disable_panels(obj);
            obj.show_panels(true);
            str = get(obj.ui_sequence,'string');
            val = get(obj.ui_sequence,'value');
            obj.gui.sequence = obj.gui.file.get('tag',str{val});
        end
        
    end
end