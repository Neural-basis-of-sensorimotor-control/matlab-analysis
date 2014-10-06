classdef SequenceOptions < PanelComponent
    %Buttons for adding and editing sequences
    properties
        ui_parse_protocol
        ui_add_sequence
        ui_edit_sequence
        ui_remove_sequence
    end
    
    methods
        function obj = SequenceOptions(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_parse_protocol = mgr.add(sc_ctrl('pushbutton','Parse protocol',...
                @parse_protocol_callback),100);
            obj.ui_add_sequence = mgr.add(sc_ctrl('pushbutton','Add sequence',...
                @affect_sequence_callback),100);
            mgr.newline(20);
            obj.ui_edit_sequence = mgr.add(sc_ctrl('pushbutton','Edit sequence',...
                @affect_sequence_callback),100);
            obj.ui_remove_sequence = mgr.add(sc_ctrl('pushbutton','Remove sequence',...
                @affect_sequence_callback),100);
            
            function parse_protocol_callback(~,~)
                obj.show_panels(false);
                set(obj.gui.current_view,'Visible','off');
                [protocolfile, pdir] = uigetfile('*.txt','Select protocol file');
                if isnumeric(protocolfile), return; end
                protocolfile = fullfile(pdir, protocolfile);
                obj.gui.experiment.update_from_protocol(protocolfile);
                obj.gui.has_unsaved_changes = true;
                set(obj.gui.current_view,'Visible','on');
       %         obj.gui.file = obj.gui.file;
                if obj.gui.experiment.n
                    obj.gui.file = obj.gui.experiment.get(1);
                end
            end
            
            function affect_sequence_callback(src,~)
                obj.show_panels(false);
                dlg = figure();
                set(dlg,'windowStyle','modal','Name','Add sequence');
                setwidth(dlg,355);
                setheight(dlg,62);
                
                dialogmgr = ScLayoutManager(dlg);
                dialogmgr.newline();
                dialogmgr.add(uicontrol('style','text','string','Tag:'),50);
                ui_new_tag = dialogmgr.add(uicontrol('style','edit','string',[]),50);
                dialogmgr.add(uicontrol('style','text','string','tmin:'),50);
                ui_tmin = dialogmgr.add(uicontrol('style','edit','string',[]),50);
                dialogmgr.add(uicontrol('style','text','string','tmax:'),50);
                ui_tmax = dialogmgr.add(uicontrol('style','edit','string',[]),50);
                dialogmgr.add(uicontrol('style','text','string','(seconds)'),50);
                
                dialogmgr.newline();
                
                switch src
                    case obj.ui_add_sequence
                        if obj.gui.file.signals.n
                            dialogmgr.add(uicontrol('style','pushbutton','String',...
                                'Set time span to maximal time range for file',...
                                'Callback',@max_time_span_callback),295);
                        end
                        dialogmgr.newline();
                        dialogmgr.add(uicontrol('style','pushbutton','String',...
                            'Add','Callback',@sequence_callback),175);
                    case obj.ui_remove_sequence
                        dialogmgr.add(uicontrol('style','pushbutton','String',...
                            'Remove','Callback',@remove_sequence_callback),170);
                        set(ui_new_tag,'enable','off','string',obj.gui.sequence.tag);
                        set(ui_tmin,'enable','off','string',obj.gui.sequence.tmin);
                        set(ui_tmax,'enable','off','string',obj.gui.sequence.tmax);
                    case obj.ui_edit_sequence
                        dialogmgr.add(uicontrol('style','pushbutton','String',...
                            'Update','Callback',@sequence_callback),175);
                        set(ui_new_tag,'string',obj.gui.sequence.tag);
                        set(ui_tmin,'string',obj.gui.sequence.tmin);
                        set(ui_tmax,'string',obj.gui.sequence.tmax);
                    otherwise
                        error(['debugging error: ' src])
                end
                
                dialogmgr.add(uicontrol('style','pushbutton','String','Cancel',...
                    'Callback',@(src,evt) close(dlg)),175);
                
                function max_time_span_callback(~,~)
                    set(ui_tmin,'string',0);
                    N = cell2mat(obj.gui.file.signals.values('N'));
                    dt = cell2mat(obj.gui.file.signals.values('dt'));
                    set(ui_tmax,'string',max(N.*dt));
                end
                
                function sequence_callback(~,~)
                    tmin = str2double(get(ui_tmin,'string'));
                    tmax = str2double(get(ui_tmax,'string'));
                    tag = deblank(get(ui_new_tag,'string'));
                    if isempty(tmin) || isnan(tmin) || isempty(tmax) || isnan(tmax) || tmin>=tmax
                        msgbox('Illegal time range values');
                        return;
                    end
                    if isempty(tag)
                        msgbox('Tag must be non-empty string');
                        return;
                    end
                    if obj.gui.file.has('tag',tag)
                        msgbox('Tag is already in use');
                        return;
                    end
                    if src==obj.ui_add_sequence
                        sequence = ScSequence(obj.gui.file,tag,tmin,tmax);
                        sequence.comment = '';
                        obj.gui.file.add(sequence);
                        obj.gui.sequence = sequence;
                    elseif src==obj.ui_edit_sequence
                        obj.gui.sequence.tmin = tmin;
                        obj.gui.sequence.tmax = tmax;
                        obj.gui.sequence.tag = tag;
                    end
                    obj.gui.has_unsaved_changes = true;
                    close(dlg);
%                     clf(obj.gui.current_view);
%                     show_file(h);
                   % obj.gui.file = obj.gui.file;
                end
                
                function remove_sequence_callback(~,~)
                    obj.gui.file.list(obj.gui.sequence.index) = [];
                    obj.gui.has_unsaved_changes = true;
                    close(dlg);
%                     clf(obj.gui.current_view);
%                     show_file(h);
                    obj.gui.file = obj.gui.file;
                end
            end
            
            
        end
        
    end
end