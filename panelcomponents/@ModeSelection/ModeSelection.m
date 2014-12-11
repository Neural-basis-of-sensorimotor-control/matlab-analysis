classdef ModeSelection < PanelComponent
    %Select viewer
    properties
        ui_mode
    end
    
    methods
        function obj = ModeSelection(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(5);
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Mode'),100);
            obj.ui_mode = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.viewer_callback(),'visible','off'),100);
            mgr.newline(5);
%             mgr.newline(20);
%             mgr.add(sc_ctrl('pushbutton','Update',@(~,~) obj.update_callback()),200);
        end
        
        function initialize(obj)
            
            [~,str_] = enumeration('ScGuiState');
            set(obj.ui_mode,'string',str_,'value',find(obj.gui.parent.mode == enumeration('ScGuiState')),...
                'visible','on');

        end
        
%         function updated = update(obj)
%             str = get(obj.ui_mode,'string');
%             val = get(obj.ui_mode,'value');
%             [enum,enum_str] = enumeration('ScGuiState');
%             ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
%             mode = enum(ind);
%             updated = mode == obj.gui.mode;
%         end
    end
    
    methods (Access = 'protected')
        function viewer_callback(obj)
            %obj.show_panels(false);
            str = get(obj.ui_mode,'string');
            val = get(obj.ui_mode,'value');
            [enum,enum_str] = enumeration('ScGuiState');
            ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
            mode = enum(ind);
            if mode ~= obj.gui.mode
                set(obj.gui.btn_window,'CloseRequestFcn','closereq');
                close all
                if isempty(findall(0,'type','figure'))
                    prev_gui = obj.gui;
                    obj.gui.parent.mode = mode;
                    delete(prev_gui)
                else
                    set(obj.btn_window,'CloseRequestFcn',@(~,~) obj.close_request());
                end
            end
        end
%         function update_callback(obj)            
%             str = get(obj.ui_mode,'string');
%             val = get(obj.ui_mode,'value');
%             [enum,enum_str] = enumeration('ScGuiState');
%             ind = cellfun(@(x) strcmp(x,str{val}),enum_str);
%             mode = enum(ind);
%             if mode ~= obj.gui.parent.mode
%                 obj.gui.parent.mode = mode;
%             else
%                 obj.show_panels(true);
%             end
%         end
    end
end