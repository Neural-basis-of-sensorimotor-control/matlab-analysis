classdef SequenceTextBox < GuiComponent
    properties
        ui_text
    end
    
    methods
        function obj = SequenceTextBox(gui)
            obj@GuiComponent(gui);
        end
        
        function populate_panel(obj,mgr)
            mgr.newline(60);
            obj.ui_text = mgr.add(sc_ctrl('text',[],[],'Value',2),200);
            
            sc_addlistener(obj.gui,'sequence',@(~,~) obj.sequence_listener,obj.uihandle);
        end
        
        function initialize_panel(obj)
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
                set(obj.ui_text,'string',txt);
            end
        end
        
    end
end