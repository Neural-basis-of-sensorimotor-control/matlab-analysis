function show_experiment(h)

global DEBUG
if DEBUG
    h.experiment.sc_clear();
    h.file = h.experiment.get(1);
%    h.file.sc_loadtimes();
    clf(h.current_view,'reset');
    show_file(h);
    return
end

buttonpanel = uipanel('Title','Experiment');
btnmgr = ScLayoutManager(buttonpanel);
btnmgr.newline(15);
btnmgr.newline(20);
btnmgr.add(getuitext('Directory:'),60);
ui_fdir = btnmgr.add(uicontrol('style','edit','string',h.experiment.fdir,...
    'callback',@fdir_callback),300);

    function fdir_callback(~,~)
        h.experiment.fdir = get(ui_fdir,'string');
        h.has_unsaved_changes = true;
    end

btnmgr.add(uicontrol('style','pushbutton','string','Browse','callback',...
    @browse_callback),60);

    function browse_callback(~,~)
        fdir = uigetdir();
        if ~isnumeric(fdir)
            h.experiment.fdir = fdir;
            set(ui_fdir,'string',fdir);
            h.has_unsaved_changes = true;
        end
    end

btnmgr.newline;
btnmgr.add(getuitext('Tag:'),60);
ui_tag = btnmgr.add(uicontrol('style','text','string',[]),160);
ui_load = btnmgr.add(uicontrol('style','pushbutton','string','Load','callback',...
    @load_callback,'enable','off'));

    function load_callback(~,~)
       % h.experiment.sc_clear();
       % if h.file.sc_loadtimes();
            clf(h.current_view);
            show_file(h);
      %  end
    end

btnmgr.newline(2);
btnmgr.trim;

table = uitable('data',{h.experiment.list.tag}','CellSelectionCallback',...
    @cell_selection_callback,'ColumnName',{'Tag','Comment'},'RowName',[]);

    function cell_selection_callback(~,eventdata)
        row = eventdata.Indices(1);
        h.file = h.experiment.get(row);
        set(ui_tag,'string',h.file.tag);
        set(ui_load,'enable','on');
    end

figmgr = ScLayoutManager(h.current_view);
figmgr.newline(getheight(buttonpanel));
figmgr.add(buttonpanel);
figmgr.newline(getheight(table));
figmgr.add(table);
%todo vad händer om height > figure height?
setheight(h.current_view,getheight(buttonpanel)+getheight(table));
resize_fcn;

set(h.current_view,'ResizeFcn',@resize_fcn,'menubar', 'none');
set(h.current_view,'CloseRequestFcn',@(src,evt) sc_close_request(src,evt,h),...
    'menubar','none','Color',[0 0 0]); 


    function resize_fcn(~,~)
        figmgr.trim();
        setwidth(table,getwidth(h.current_view));
        set(table,'ColumnWidth',{100 (getwidth(h.current_view)-100)});
    end

end