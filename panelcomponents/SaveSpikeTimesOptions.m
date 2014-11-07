classdef SaveSpikeTimesOptions < SavePlotOptions
    
    methods
        function obj = SaveSpikeTimesOptions(panel)
            obj@SavePlotOptions(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_filename = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filename_callback()),150);
            obj.ui_filenbr = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filenbr_callback()),50);
            mgr.newline(20);
            obj.ui_savebutton = mgr.add(sc_ctrl('pushbutton','Save spike times to .dat',@(~,~) obj.save_spiketimes_callback()),200);
        end
        function initialize(obj)
            set(obj.ui_filename,'String',obj.filename);
            set(obj.ui_filenbr,'String',obj.filenbr);
        end
        
    end
    
    methods (Access = 'protected')
        function sequence_listener(obj)
            if ~isempty(obj.gui.sequence)
                obj.filename = sprintf('%s_%s_spikes_', obj.gui.file.tag, obj.gui.sequence.tag);
                set(obj.ui_filename,'String',obj.filename);
            end
        end
        
        
        function save_spiketimes_callback(obj)
            alltriggers = obj.sequence.gettriggers(obj.sequence.tmin,obj.sequence.tmax);
            dlg = figure();
            set(dlg,'windowStyle','modal','Name','Save spiketimes');
            setwidth(dlg,355);
            setheight(dlg,20*(alltriggers.n+2)+2);
            sety(dlg,getheight(obj.gui.plot_window)-getheight(dlg)-20);
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
                obj.gui.lock_screen(true,'Saving spike data (might take some time ... ');
                triggers = alltriggers.sublist(savetriggers);
                headers = headers(savetriggers);
                obj.filename = get(obj.ui_filename,'string');
                obj.filenbr = str2double(get(obj.ui_filenbr,'string'));
                savename = sprintf('%s%.3i.dat',obj.filename, obj.filenbr);
                if exist(savename,'file')==2
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
                
                fid = fopen(savename,'w');
                for i=1:numel(headers)-1
                    fprintf(fid,'%s,',headers{i});
                end
                fprintf(fid,'%s\n',headers{end});
                alltimes = cell(numel(headers));
                for i=1:triggers.n
                    alltimes(i) = {triggers.get(i).gettimes(obj.gui.tmin,obj.gui.tmax)};
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
                obj.filenbr = obj.filenbr+1;
                set(obj.ui_filenbr,'String',obj.filenbr);
                obj.gui.lock_screen(false,'Done');
            end
            
        end
        function filename_callback(obj)
            obj.filename = get(obj.ui_filename,'string');
        end
        function filenbr_callback(obj)
            obj.filenbr = str2double(get(obj.ui_filenbr,'string'));
        end
    end
end