function panel = get_histogrampanel(h)

histnbr = 1;

h.update_histogrampanel_fcn = @update_panel;

    function update_panel()
        filename = sprintf('%s_%s_hist_%.3i',h.file.tag,h.sequence.tag,histnbr);
        set(ui_filename,'String',filename);
        hist_callback(ui_default_histogram);
    end

panel = uipanel('title','Histogram');
h.histogrampanel = panel;

mgr = ScLayoutManager(panel);
mgr.newline(15);

mgr.newline(20);
mgr.add(getuitext('Pretrigger'),75);
ui_pretrigger = mgr.add(uicontrol('style','edit','String',...
    h.hist_pretrigger,'callback',@hist_callback),75);
mgr.add(getuitext('Posttrigger'),75);
ui_posttrigger = mgr.add(uicontrol('style','edit','String',...
    h.hist_posttrigger,'callback',@hist_callback),70);
mgr.newline(20);
mgr.add(getuitext('Bin size:'),75);
ui_binwidth = mgr.add(uicontrol('style','edit','String',...
    h.hist_binwidth,'callback',@hist_callback),75);

mgr.newline(20);
ui_default_histogram = mgr.add(uicontrol('style','pushbutton','String','Default','callback',...
    @hist_callback),75);
ui_isi_pdf = mgr.add(uicontrol('style','pushbutton','String','ISI pdf','callback',...
    @hist_callback),75);
mgr.add(uicontrol('style','pushbutton','string','Raster ',...
    'callback',@plot_raster_callback),70);

mgr.newline(20);
mgr.add(getuitext('Filename:'),50);
ui_filename = mgr.add(uicontrol('style','edit','HorizontalAlignment','left'),195);
ui_save_histogram = mgr.add(uicontrol('style','pushbutton','String','Save','callback',...
    @hist_callback),50);

mgr.newline(2);
mgr.trim;

    function plot_raster_callback(~,~)
        if isempty(h.waveform)
            msgbox('No waveform chosen');
            return;
        end
        figure;
        set(gcf,'WindowStyle','modal','Name','Raster plot');
        [t,sweep] = h.waveform.perievent(h.triggertimes, h.pretrigger, h.posttrigger);
        subplot(6,1,1:4)
        plot(t,sweep,'k.','markersize',1,'Color',[0 0 0]);
        set(gca,'YDir','reverse')
        set(gca,'FontSize',14);
        xlabel(gca,'Time [s]')
        ylabel(gca,'Sweep nbr')
        xlim([h.pretrigger h.posttrigger])
        subplot(6,1,5);
        spiketimes = h.waveform.perievent(h.triggertimes,h.pretrigger,h.posttrigger);
        if ~isempty(spiketimes)
            edges = (h.pretrigger:h.hist_binwidth:h.posttrigger)';
            firing = histc(spiketimes,edges)/(numel(h.triggertimes) * h.hist_binwidth);
            bar(edges,firing,'EdgeColor',[1 0 0]);
            ylabel('Firing [Hz]')
        end
        xlim([h.pretrigger h.posttrigger])
        subplot(6,1,6)
        hold on
        stims = h.sequence.stims;
        sweeps = 1:numel(h.triggertimes);
        height = 0;
        for i=1:stims.n
            for j=1:stims.get(i).triggers.n
                trg = stims.get(i).triggers.get(j);
                height = height+1;
                plot([h.pretrigger h.posttrigger],[height height]);
                times = trg.perievent(h.triggertimes(sweeps),h.pretrigger,h.posttrigger);
                for k=1:numel(times)
                    plot(times(k)*ones(2,1),height+[-.5 .5],'LineWidth',2)
                end
            end
        end
        xlim([h.pretrigger h.posttrigger])
    end

    function hist_callback(src,~)
        if isempty(h.waveform)
            set(h.histogramaxes,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                [1 1 1],'Box','off');
            cla(h.histogramaxes);
            return
        end
        switch src
            case ui_pretrigger
                h.hist_pretrigger = str2double(get(ui_pretrigger,'String'));
            case ui_posttrigger
                h.hist_posttrigger = str2double(get(ui_posttrigger,'String'));
            case ui_binwidth
                h.hist_binwidth = str2double(get(ui_binwidth,'String'));
            case ui_default_histogram
            case ui_isi_pdf
            case ui_save_histogram
            otherwise
                error(['debugging error :  option ' src ' unknown']);
        end
        switch src
            case ui_default_histogram
                set(h.histogramaxes,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                    [1 1 1],'Box','off');
                spiketimes = h.waveform.perievent(h.triggertimes,h.hist_pretrigger,...
                    h.hist_posttrigger);
                if isempty(spiketimes)
                    set(h.histogramaxes,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                        [1 1 1],'Box','off');
                    cla(h.histogramaxes);
                    return
                end
                edges = (h.hist_pretrigger:h.hist_binwidth:h.hist_posttrigger)';
                firing = histc(spiketimes,edges)/(numel(h.triggertimes) * h.hist_binwidth);
                bar(h.histogramaxes,edges,firing,'EdgeColor',[1 0 0]);
                xlabel(h.histogramaxes,'Time [s]','Color',[1 1 1])
                ylabel(h.histogramaxes,'Firing [Hz]')
                set(h.histogramaxes,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                    [1 1 1],'Box','off');
            case ui_isi_pdf
                isi = diff(h.waveform.gettimes(h.tmin,h.tmax));
                if isempty(isi)
                    cla(h.histogramaxes);
                    set(h.histogramaxes,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                        [1 1 1],'Box','off');
                    return;
                end
                edges = (h.hist_pretrigger:h.hist_binwidth:h.hist_posttrigger)';
                isi_pdf = histc(isi,edges)/numel(isi);
                plot(h.histogramaxes,edges,isi_pdf,'Color',[1 0 0],'LineWidth',4);
                xlabel(h.histogramaxes,'ISI time [s]')
                ylabel(h.histogramaxes,'pdf')
                set(h.histogramaxes,'Color',[0 0 0],'XColor',[1 1 1],'YColor',...
                    [1 1 1],'Box','off');
        end
        axis(h.histogramaxes,'tight');
        if src == ui_save_histogram
            child = get(h.histogramaxes,'Children');
            if numel(child)~=1
                msgbox('Cannot save this type of plot');
                return
            end
            XData = get(child,'XData')';
            YData = get(child,'YData')';
            c = [1e3*XData YData];
            savename = [get(ui_filename,'String') '.dat'];
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
            dlmwrite(savename,c);
            histnbr = histnbr + 1;
            filename = sprintf('%s_%s_hist_%.3i',h.file.tag,h.sequence.tag,histnbr);
            set(ui_filename,'String',filename);
        end
    end



end