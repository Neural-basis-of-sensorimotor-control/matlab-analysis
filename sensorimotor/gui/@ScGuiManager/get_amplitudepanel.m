function panel = get_amplitudepanel(obj)

panel = uipanel('title','Amplitude');
sc_addlistener(obj,'ampl_',@amplitude_listener,panel);
obj.waveformpanel = panel;
mgr = ScLayoutManager(panel);
mgr.newline(15);

mgr.newline(20);
ui_clear_sweep = mgr.add(sc_ctrl('pushbutton','Clear sweep',@clear_sweep_callback),100);
sc_addlistener(obj,'mouse_press_',@mouse_press_listener,ui_clear_sweep);

    function clear_sweep_callback(~,~)
        obj.has_unsaved_changes = true;
        stimtime = obj.triggertimes(obj.sweep(1));
        obj.ampl.add_data(stimtime,1:4,nan(4,1));
        obj.mouse_press = 1;
        obj.plot_fcn();
    end

mgr.add(sc_ctrl('pushbutton','Delete all',@delete_all_callback),100);

    function delete_all_callback(~,~)
        answer  = questdlg(sprintf('Do you really want to delete object %s?',obj.ampl.tag));
        if strcmpi(answer,'Yes')
            obj.has_unsaved_changes = true;
            obj.sequence.ampl_list.remove(obj.ampl);
            obj.ampl = [];
        end 
    end

mgr.add(sc_ctrl('pushbutton','Save to file',@save_to_file_callback),100);

    function save_to_file_callback(~,~)
        stimtimes = obj.triggertimes;
        data = nan(numel(stimtimes),4);
        for k=1:numel(stimtimes)
            stimtime = stimtimes(k);                   
            data(k,:) = obj.ampl.get_data(stimtime,1:4);
        end
        data = data(all(isfinite(data),2),:);
        if isempty(data)
            msgbox('No amplitude data to save');
        else
            response_time = data(:,1);
            v_diff = data(:,4)-data(:,2);
            time_to_peak = data(:,3) - data(:,1);
            fid = fopen(get(ui_filename,'string'),'w');
            if fid ~= -1
                fprintf(fid,'%.2f,%.0f,%.0f\n',[response_time 1000*v_diff 1000*time_to_peak]);
                if fclose(fid)
                    msgbox('File did not close properly');
                end
            else
                msgbox(sprintf('Unknown error: could not open file %s.',...
                    get(ui_filename,'string')));
            end
        end
        set(ui_filename,'string',get_next_filename);
    end

mgr.newline(20);

mgr.add(sc_ctrl('text','Filename'),50);
ui_filename = mgr.add(sc_ctrl('edit','filename','',...
    'HorizontalAlignment','left'), obj.leftpanelwidth-50);

mgr.newline(2);
mgr.trim;

    function amplitude_listener(~,~)
        if isempty(obj.ampl)
            set(panel,'visible','off');
        else
            set(panel,'visible','on');
            set(ui_filename,'string',get_next_filename);
        end
    end

    function mouse_press_listener(~,~)
        if obj.mouse_press == 0 || obj.mouse_press == 2
            set(ui_clear_sweep,'visible','on');
        else
            set(ui_clear_sweep,'visible','off');
        end
    end

    function filename = get_next_filename()
        filename = '';
        savenbr = 1;
        while savenbr<2 || exist(filename,'file')==2
            filename = sprintf('%s_%s_amplitude_%s_%.3i.dat', obj.file.tag, obj.sequence.tag, ...
                obj.ampl.tag, savenbr);
            savenbr = savenbr+1;
        end
    end
end
