function panel = get_savepanel(h)

savenbr = 1;
h.update_savepanel_fcn = @update_fcn;

    function update_fcn()
        filename = sprintf('%s_%s_spiketimes_%.3i', h.file.tag, h.sequence.tag, ...
            savenbr);
        set(ui_spiketimes_fname,'String',filename);
    end

panel = uipanel('title','Save');
h.savepanel = panel;
mgr = ScLayoutManager(panel);
mgr.newline(15);
mgr.newline(20);
mgr.add(getuitext('Filename:'),50);
ui_spiketimes_fname = mgr.add(uicontrol('style','edit','HorizontalAlignment','left'),245);
mgr.newline(20);
mgr.add(uicontrol('style','pushbutton','String',...
    'Save spike times and trigger times for current waveform','callback',...
    @save_spiketimes_callback),295);

mgr.newline(20);
mgr.add(uicontrol('style','pushbutton','String','Save experiment file','callback',...
    @save_experiment_callback),295);

    function save_experiment_callback(~,~)
        saved = h.sequence.sc_save;
        if saved
            h.has_unsaved_changes = false;
        end
    end

    function save_spiketimes_callback(~,~)
        alltriggers = h.file.gettriggers(h.tmin,h.tmax);
        
        dlg = figure(); 
        set(dlg,'windowStyle','modal','Name','Save spiketimes');
        setwidth(dlg,355);
        setheight(dlg,20*(alltriggers.n+2)+2);
        sety(dlg,getheight(h.current_view)-getheight(dlg)-20);
        dialogmgr = ScLayoutManager(dlg);
        ui_savetriggers = nan(alltriggers.n,1);
        ui_labels = nan(alltriggers.n,1);
        savetriggers = true(alltriggers.n,1);
        headers = alltriggers.values('tag');
        for k=1:alltriggers.n
            dialogmgr.newline(20);
            ui_savetriggers(k) = dialogmgr.add(uicontrol('style','checkbox',...
                'String','','Value',1,'callback',...
                @(src,~) savetriggers_callback(src,k)),50);
            ui_labels(k) = dialogmgr.add(uicontrol('style','edit',...
                'String',headers{k},'callback',@(src,~) labels_callback(src,k)),...
                300);
        end
        dialogmgr.newline(20);
        ui_select_all = dialogmgr.add(uicontrol('style','checkbox','String',...
            'Select / deselect all','Value',1,...
            'callback',@(src,~) savetriggers_callback(src,1:alltriggers.n)),350);
        dialogmgr.newline(20);
        dialogmgr.add(uicontrol('style','pushbutton','String',...
            'Done','callback',@okbtn_callback),100);
        dialogmgr.add(uicontrol('style','pushbutton','String',...
            'Cancel','callback',@cancelbtn_callback),100);
        dialogmgr.newline(2);
        dialogmgr.trim;
        
        function savetriggers_callback(src,index)
            value = get(src,'value');
            savetriggers(index) = value*ones(numel(index),1);
            if src == ui_select_all
                for i=1:numel(ui_savetriggers)
                    set(ui_savetriggers(i),'value',value);
                end
            end     
        end
        
        function labels_callback(src,index)
            str = get(src,'string');
            headers(index) = {str};
        end
        
        function cancelbtn_callback(~,~)
            close(dlg);
        end
        
        function okbtn_callback(~,~)
            close(dlg);
            fprintf('\nSaving spike data (might take some time ... ');
            h.disable_all(1);
            triggers = alltriggers.sublist(savetriggers);
            headers = headers(savetriggers);
            filename = [get(ui_spiketimes_fname,'string') '.dat'];
            if exist(filename,'file')==2
                answer = questdlg('File already exists. Overwrite?','Overwrite',...
                    'Yes','No','Yes');
                if isempty(answer), answer = 'No';  end
                switch answer
                    case 'Yes'
                        %do nothing
                    case 'No'
                        return;
                    otherwise
                        error(['debugging error: command: ' answer]);
                end
            end
            
            fid = fopen(filename,'w');
            for i=1:numel(headers)-1
                fprintf(fid,'%s,',headers{i});
            end
            fprintf(fid,'%s\n',headers{end});
            alltimes = cell(numel(headers));
            for i=1:triggers.n
                alltimes(i) = {triggers.get(i).gettimes(h.tmin,h.tmax)};
            end
            index = 0;
            keep_on_writing = 1;
            while keep_on_writing
                index = index+1;
                keep_on_writing = 0;
                for i=1:numel(alltimes)-1
                    times = alltimes{i};
                    if numel(times)>=index
                        keep_on_writing = 1;
                        fprintf(fid,'%f,',times(index));
                    else
                        fprintf(fid,',');
                    end
                end
                times = alltimes{end};
                if numel(times)>=index
                    keep_on_writing = 1;
                    fprintf(fid,'%f\n',times(index));
                else
                    fprintf(fid,'\n');
                end
            end
            fclose(fid);
            savenbr = savenbr+1;
            filename = sprintf('%s_%s_spiketimes_%.3i', h.file.tag, h.sequence.tag, ...
                savenbr);
            set(ui_spiketimes_fname,'String',filename);
            fprintf('done\n');
            h.disable_all(0);
        end
    end

mgr.newline(2);
mgr.trim;

end