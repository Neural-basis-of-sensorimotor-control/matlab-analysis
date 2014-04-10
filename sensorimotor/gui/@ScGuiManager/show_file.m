function show_file(h)

global DEBUG
if DEBUG
    clf(h.current_view);
    h.file.sc_clearsignals();
    h.sequence = h.file.get(1);
   % h.sequence.sc_loadsignals(h.tmin,h.tmax);
   %loadtimes already applied, loadsignal will be customized
    show_sequence(h);
    return
end

set(h.current_view,'CloseRequestFcn',@(src,evt) sc_close_request(src,evt,h),...
    'menubar','none','Color',[0 0 0]);

buttonpanel = uipanel('Title',['File: ' h.file.tag]);
btnmgr = ScLayoutManager(buttonpanel);
btnmgr.newline(15);

btnmgr.newline(20);
btnmgr.add(uicontrol('style','pushbutton','string','File selection','callback',...
    @file_selection_callback),100);

btnmgr.newline(20);
if ~h.file.is_adq_file
    btnmgr.add(uicontrol('style','pushbutton','String','Parse protocol file',...
        'callback',@parse_protocol_callback),100);
end

ui_add_sequence = btnmgr.add(uicontrol('style','pushbutton','String',...
    'Add time limits','callback',@affect_sequence_callback),100);

ui_remove_sequence = btnmgr.add(uicontrol('style','pushbutton','String',...
    'Remove','callback',@affect_sequence_callback),100);

ui_edit_sequence = btnmgr.add(uicontrol('style','pushbutton','String',...
    'Edit','callback',@affect_sequence_callback),100);

btnmgr.newline(20);

btnmgr.add(getuitext('Tag'),60);
ui_tag = btnmgr.add(uicontrol('style','text','string',[]),160);
ui_load = btnmgr.add(uicontrol('style','pushbutton','string','Load','callback',...
    @load_callback,'enable','off'));

btnmgr.newline(2);
btnmgr.trim;

data = cell(h.file.n,2);
if h.file.n
    data(:,1) = h.file.values('tag')';
    data(:,2) = h.file.values('comment')';
    table = uitable('data',data,'CellSelectionCallback',...
    @cell_selection_callback,'ColumnName',{'Tag','Comment'},'RowName',[]);
else
    table = uitable('data',[]);
end

figmgr = ScLayoutManager(h.current_view);
figmgr.newline(getheight(buttonpanel));
figmgr.add(buttonpanel);
figmgr.newline(getheight(table));
figmgr.add(table);
resize_fcn;

set(h.current_view,'ResizeFcn',@resize_fcn);

    function cell_selection_callback(~,eventdata)
        row = eventdata.Indices(1);
        h.sequence = h.file.get(row);
        set(ui_tag,'string',h.sequence.tag);
        set(ui_load,'enable','on');
    end

    function file_selection_callback(~,~)
        clf(h.current_view,'reset');
        show_experiment(h);
    end

    function parse_protocol_callback(~,~)
        set(h.current_view,'Visible','off');
        [protocolfile, pdir] = uigetfile('*.txt','Select protocol file');
        if isnumeric(protocolfile), return; end
        protocolfile = fullfile(pdir, protocolfile);
        h.experiment.update_from_protocol(protocolfile);
        h.has_unsaved_changes = true;
        set(h.current_view,'Visible','on');
        clf(h.current_view,'reset');
        show_file(h);
    end

    function affect_sequence_callback(src,~)
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
            case ui_add_sequence
                if h.file.signals.n
                    dialogmgr.add(uicontrol('style','pushbutton','String',...
                        'Set time span to maximal time range for file',...
                        'Callback',@max_time_span_callback),295);
                end
                dialogmgr.newline();
                dialogmgr.add(uicontrol('style','pushbutton','String',...
                    'Add','Callback',@sequence_callback),175);
            case ui_remove_sequence
                dialogmgr.add(uicontrol('style','pushbutton','String',...
                    'Remove','Callback',@remove_sequence_callback),170);
                set(ui_new_tag,'enable','off','string',h.sequence.tag);
                set(ui_tmin,'enable','off','string',h.sequence.tmin);
                set(ui_tmax,'enable','off','string',h.sequence.tmax);
            case ui_edit_sequence
                dialogmgr.add(uicontrol('style','pushbutton','String',...
                    'Update','Callback',@sequence_callback),175);
                set(ui_new_tag,'string',h.sequence.tag);
                set(ui_tmin,'string',h.sequence.tmin);
                set(ui_tmax,'string',h.sequence.tmax);
            otherwise
                error(['debugging error: ' src])
        end
                     
        dialogmgr.add(uicontrol('style','pushbutton','String','Cancel',...
            'Callback',@(src,evt) close(dlg)),175);
                
        function max_time_span_callback(~,~)
            set(ui_tmin,'string',0);
            N = cell2mat(h.file.signals.values('N'));
            dt = cell2mat(h.file.signals.values('dt'));
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
            if h.file.has('tag',tag)
                msgbox('Tag is already in use');
                return;
            end
            if src==ui_add_sequence
                sequence = ScSequence(h.file,tag,tmin,tmax);
                sequence.comment = '';
                h.file.add(sequence);
            elseif src==ui_edit_sequence
                h.sequence.tmin = tmin;
                h.sequence.tmax = tmax;
                h.sequence.tag = tag;
            end
            h.has_unsaved_changes = true;
            close(dlg);
            clf(h.current_view);
            show_file(h);
        end
        
        function remove_sequence_callback(~,~)
            h.file.list(h.sequence.index) = [];
            h.has_unsaved_changes = true;
            close(dlg);
            clf(h.current_view);
            show_file(h);
        end
    end

    function load_callback(~,~)
        clf(h.current_view);
        h.file.sc_clearsignals();
        show_sequence(h);
    end

    function resize_fcn(~,~)
        figmgr.trim();
        setwidth(table,getwidth(h.current_view));
        set(table,'ColumnWidth',{100 (getwidth(h.current_view)-100)});
    end
end