classdef SequenceTextBox < PanelComponent
    properties
        ui_text
    end
    
    methods
        function obj = SequenceTextBox(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(60);
            obj.ui_text = mgr.add(sc_ctrl('text',[],[],'Value',2),200);
            sc_addlistener(obj.gui,'sequence',@(~,~) obj.sequence_listener,obj.uihandle);
        end
        
        function initialize(obj)
            obj.sequence_listener();
        end
        
    end
    
    methods (Access = 'private')
        
        function sequence_listener(obj)
            if isempty(obj.gui.sequence)
                set(obj.ui_text,'string',[]);
            else
                txt = sprintf('Tag: %s Time: %i - %i\n%s',obj.gui.sequence.tag,...
                    floor(obj.gui.sequence.tmin),floor(obj.gui.sequence.tmax),...
                    obj.gui.sequence.comment);
                set(obj.ui_text,'string',txt,'BackgroundColor',[1 1 1],...
                    'ForegroundColor',[0 0 1]);
            end
        end
        
    end
end