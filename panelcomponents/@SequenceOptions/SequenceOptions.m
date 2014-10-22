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
                @(~,~) obj.parse_protocol_callback),100);
            obj.ui_add_sequence = mgr.add(sc_ctrl('pushbutton','Add sequence',...
                @(~,~) obj.affect_sequence_callback(obj.ui_add_sequence)),100);
            mgr.newline(20);
            obj.ui_edit_sequence = mgr.add(sc_ctrl('pushbutton','Edit sequence',...
                @(~,~) obj.affect_sequence_callback(obj.ui_edit_sequence)),100);
            obj.ui_remove_sequence = mgr.add(sc_ctrl('pushbutton','Remove sequence',...
                @(~,~) obj.affect_sequence_callback(obj.ui_remove_sequence)),100);
            mgr.newline(20);
        end
        
    end
    methods (Access='protected')
        function parse_protocol_callback(obj)
            if obj.gui.file.is_adq_file
                msgbox('Parsing only possible for Spike2 files');
                return
            end
            obj.show_panels(false);
            obj.gui.lock_screen(true,'Wait, parsing...');
            [protocolfile, pdir] = uigetfile('*.txt','Select protocol file',obj.gui.experiment.fdir);
            if ~isnumeric(protocolfile)
                protocolfile = fullfile(pdir, protocolfile);
                obj.gui.experiment.update_from_protocol(protocolfile);
                obj.gui.has_unsaved_changes = true;
                if obj.gui.experiment.n
                    obj.gui.set_file(obj.gui.experiment.get(1));
                end
            end
            obj.gui.lock_screen(false);
        end
        
        
        function affect_sequence_callback(obj,src)
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
                            'Callback',@(~,~) obj.max_time_span_callback(ui_tmin,ui_tmax) ),295);
                    end
                    dialogmgr.newline();
                    dialogmgr.add(uicontrol('style','pushbutton','String',...
                        'Add','Callback',@(~,~) obj.sequence_callback(src,dlg,ui_tmin,ui_tmax,ui_new_tag)),175);
                case obj.ui_remove_sequence
                    dialogmgr.add(uicontrol('style','pushbutton','String',...
                        'Remove','Callback',@(~,~) obj.remove_sequence_callback(dlg)),170);
                    set(ui_new_tag,'enable','off','string',obj.gui.sequence.tag);
                    set(ui_tmin,'enable','off','string',obj.gui.sequence.tmin);
                    set(ui_tmax,'enable','off','string',obj.gui.sequence.tmax);
                case obj.ui_edit_sequence
                    dialogmgr.add(uicontrol('style','pushbutton','String',...
                        'Update','Callback',@(~,~) obj.sequence_callback(src,dlg,ui_tmin,ui_tmax,ui_new_tag)),175);
                    set(ui_new_tag,'string',obj.gui.sequence.tag);
                    set(ui_tmin,'string',obj.gui.sequence.tmin);
                    set(ui_tmax,'string',obj.gui.sequence.tmax);
                otherwise
                    error(['debugging error: ' src])
            end
            
            dialogmgr.add(uicontrol('style','pushbutton','String','Cancel',...
                'Callback',@(src,evt) close(dlg)),175);
            
        end
        
    end
    
    methods (Access = 'protected')
        function max_time_span_callback(obj,ui_tmin,ui_tmax)
            set(ui_tmin,'string',0);
            N = cell2mat(obj.gui.file.signals.values('N'));
            dt = cell2mat(obj.gui.file.signals.values('dt'));
            set(ui_tmax,'string',max(N.*dt));
        end
        
        function sequence_callback(obj,src,dlg,ui_tmin,ui_tmax,ui_new_tag)
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
                obj.gui.set_sequence(sequence);
            elseif src==obj.ui_edit_sequence
                obj.gui.sequence.tmin = tmin;
                obj.gui.sequence.tmax = tmax;
                obj.gui.sequence.tag = tag;
            end
            obj.gui.has_unsaved_changes = true;
            close(dlg);
        end
        
        function remove_sequence_callback(obj,dlg)
            obj.gui.file.list(obj.gui.sequence.index) = [];
            obj.gui.has_unsaved_changes = true;
            close(dlg);
            obj.gui.set_file(obj.gui.file);
        end
    end
end