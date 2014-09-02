classdef GuiManager < handle
    properties (SetObservable)
        current_view
        plotchannels
        
        sequence
    end
    
%     methods (Abstract)
%         plotchannels(obj)
%     end
    
    methods
        function obj = GuiManager()
            obj.current_view = gcf;
            obj.plotchannels = ScList();
        end
        
        function layout(obj)
            clf(obj.current_view);
           panel = uipanel('Title','Sequence','Parent',obj.current_view);
           mgr = ScLayoutManager(panel);
           mgr.newline(15);
           mgr.newline(20);
           mgr.add(sc_ctrl('text','Sequence'),100);
           ui_sequence = mgr.add(sc_ctrl('text',[]),100);
           mgr.add(sc_ctrl('pushbutton','Change',@change_sequence),100);
           mgr.newline(25);
           mgr.add(sc_ctrl('text','Number of channels'),100);
           mgr.add(sc_ctrl('popupmenu',1:10,@nbr_of_channels),100);
           mgr.newline(20);
           mgr.add(sc_ctrl('pushbutton','Update',@update),100);
           mgr.newline(2);
           mgr.trim;
           sc_addlistener(obj,'sequence',@sequence_listener,panel);
           
           %Update
           obj.sequence = obj.sequence;
           
            function change_sequence(~,~)
                obj.show_file();
            end
            
            function nbr_of_channels(~,~)
                warning('not implemented yet');
            end
            
            function update(~,~)
                obj.layout();
            end
            
            function sequence_listener(~,~)
                if isempty(obj.sequence)
                    set(ui_sequence,'string',[]);
                else
                    set(ui_sequence,'string',obj.sequence.tag);
                end
            end
            
        end
    end
end