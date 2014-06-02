function panel = get_plotpanel(obj)

savenbr = 1;

panel = uipanel('title','Plot');

obj.plotpanel = panel;
mgr = ScLayoutManager(panel);
mgr.newline(15);

mgr.newline(20);
mgr.add(getuitext('Set v = 0 for t = '),80);
ui_t_offset = mgr.add(uicontrol('style','edit','string',obj.t_offset,...
    'callback',@plot_callback),50);
mgr.add(getuitext('s     (leave empty to disable)'),140);

mgr.newline(20);
ui_trigger_time = mgr.add(sc_ctrl('text',[]),200);

mgr.newline(20);
mgr.add(getuitext('Sweeps'),50);
ui_sweep = mgr.add(uicontrol('style','edit','string',num2str(obj.sweep),...
    'callback',@plot_callback),190);

ui_nbr_of_stims = mgr.add(getuitext(['(' num2str(numel(obj.triggertimes)) ')']),...
    40);

mgr.newline(20);
ui_previous = mgr.add(uicontrol('style','pushbutton','string','Previous',...
    'callback',@plot_callback),70);
ui_next = mgr.add(uicontrol('style','pushbutton','string','Next',...
    'callback',@plot_callback),70);
mgr.add(getuitext('Increment'),70);
ui_increment = mgr.add(uicontrol('style','edit','string',1),70);

mgr.newline(20);
ui_zoom = mgr.add(uicontrol('style','pushbutton','string','Zoom',...
    'callback',@zoom_on_callback),70);

ui_pan = mgr.add(uicontrol('style','pushbutton','string','Pan',...
    'callback',@pan_on_callback),70);

mgr.add(uicontrol('style','pushbutton','string','Reset',...
    'callback',@reset_callback),70);
mgr.add(uicontrol('style','pushbutton','string','Y zoom out',...
    'callback',@y_zoom_out_callback),70);

mgr.newline(20);
ui_plot_sweep = mgr.add(uicontrol('style','pushbutton','string','Update',...
    'callback',@plot_callback),70);
ui_plot_all = mgr.add(uicontrol('style','pushbutton','string','Plot all',...
    'callback',@plot_callback),70);
ui_plot_avg = mgr.add(uicontrol('style','pushbutton','string','Plot average',...
    'callback',@plot_callback),70);
ui_plot_std = mgr.add(uicontrol('style','pushbutton','string','Plot avg +/- std',...
    'callback',@plot_callback),85);

if obj.state == ScGuiState.spike_detection
    mgr.newline(20);
    mgr.add(getuitext('Filename:'),50);
    ui_filename = mgr.add(uicontrol('style','edit','HorizontalAlignment','left'),190);
    mgr.add(uicontrol('style','pushbutton','String','Save','callback',...
        @save_signal_callback),50);
end

if obj.extrasignalaxes.n
    mgr.newline(20);
    ui_save_channel_2 = mgr.add(uicontrol('style','checkbox','String',...
        'Save channel 2 too','Value',0),100);
else
    ui_save_channel_2 = [];
end

mgr.newline(2);
mgr.trim;

%Add function handles
%todo: replace by listeners as much as possible
obj.plot_stims_fcn = @plot_stims;
obj.default_plot_fcn = @default_plot_fcn;
obj.update_plotpanel_fcn = @update_plot_fcn;
obj.plot_fcn = obj.default_plot_fcn;
obj.plot_waveform_shapes_fcn = @plot_waveform_shapes;

    function plot_waveform_shapes(sweeps,v,btn_down_fcn)
        
        if obj.plot_waveform_shapes
            [wfpos,time] = sc_get_sweeps(obj.wfpos,0, ...
                obj.triggertimes(sweeps),obj.pretrigger,obj.posttrigger,obj.signal.dt);
            if obj.no_trigger,    time = time + obj.triggertimes(sweeps(1));  end
            for i=1:size(v,2)
                pos = wfpos(:,i);
                plothandles = sc_piecewiseplot(obj.signalaxes,time(pos),v(pos,i),'Color',[1 1 1],'LineWidth',2);
                if ~isempty(btn_down_fcn)
                    for k=1:numel(plothandles)
                        set(plothandles(k),'ButtonDownFcn',btn_down_fcn);
                    end
                end
            end
        end
        
    end

    function default_plot_fcn(sweep)
        
        if nargin<1,    sweep = obj.sweep;  end
        
        %Plot stims
        obj.plot_stims_fcn(sweep);
        
        grid(obj.signalaxes,'on');
        obj.initplot(sweep,[],obj.plot_waveform_shapes);
        
        for i=1:obj.extrasignalaxes.n
            sah = obj.extrasignalaxes.get(i);
            [v,time] = sc_get_sweeps(sah.signal.v,0, ...
                obj.triggertimes(sweep),obj.pretrigger,obj.posttrigger,sah.signal.dt);
            if obj.no_trigger && numel(sweep)
                time = time+obj.triggertimes(obj.sweep(1));
            end
            cla(sah.axeshandle);
            hold(sah.axeshandle,'on');
            grid(sah.axeshandle,'on')
            for j=1:size(v,2)
                plot(sah.axeshandle,time,v(:,j),'Color',[1 0 0],'LineWidth',2);
            end
            ylabel(sah.axeshandle,sah.signal.tag);
            set(sah.axeshandle,'XColor',[1 1 1],'YColor',[1 1 1],...
                'Color',[0 0 0]);
        end
        %  axis(h.signalaxes,[xl(1),xl(2),yl(1),yl(2)]);
    end



    function plot_stims(sweeps)
        
        if nargin<1,    sweeps = obj.sweep;  end
        
        cla(obj.stimaxes);
        hold(obj.stimaxes,'on');
        if isempty(sweeps), return; end
        
        alltriggers = obj.sequence.gettriggers(obj.tmin,obj.tmax);
        plottriggers = ScCellList();
        for k=1:alltriggers.n
            if k>numel(obj.show_triggers) || obj.show_triggers(k)
                plottriggers.add(alltriggers.get(k));
            end
        end
        for k=1:plottriggers.n
            if isa(plottriggers.get(k),'ScWaveform')
                plotcolor = [1 1 1];
            else
                plotcolor = [.5 .5 0];
            end
            times = plottriggers.get(k).perievent(obj.triggertimes(sweeps),...
                obj.pretrigger,obj.posttrigger);
            if obj.no_trigger,    times = times + obj.triggertimes(sweeps(1));  end

            trange = [obj.pretrigger; obj.posttrigger];
            if obj.no_trigger,    trange = trange + obj.triggertimes(sweeps(1));    end 
            plot(obj.stimaxes,trange,[k k],'Color',plotcolor);
            for j=1:numel(times)
                plot(obj.stimaxes,times(j)*ones(2,1),k+[-.5 .5],'LineWidth',2,...
                    'color',plotcolor);
            end
        end
        set(obj.stimaxes,'YLim',[0 plottriggers.n+1],'YTick',...
            1:plottriggers.n,'YTickLabel',plottriggers.values('tag'),...
            'YColor',[1 1 1],'XColor',[0 0 0],'Color',[0 0 0]);
    end

    function update_plot_fcn()
        if obj.state == ScGuiState.spike_detection
            filename = sprintf('%s_%s_signal_%.3i',...
                obj.file.tag, obj.sequence.tag, savenbr);
            set(ui_filename,'String',filename);
        end
    end

    function save_signal_callback(~,~)
        plothandles = get(obj.signalaxes,'Children');
        xl = get(obj.signalaxes,'xlim');
        m = [];
        for i=1:numel(plothandles)
            if strcmpi(get(plothandles(i),'Type'),'line')
                XData = get(plothandles(i),'XData')';
                YData = get(plothandles(i),'YData')';
                pos = XData>=xl(1) & XData<=xl(2);
                if isempty(m)
                    m = nan(nnz(pos),numel(plothandles)+1);
                    m(:,1) = XData(pos);
                elseif nnz(pos)~=size(m,1)
                    msgbox('Cannot save this type of plot.');
                    return;
                end
                m(:,i+1) = YData(pos); %#ok<AGROW>
            end
        end
        m = m(:,all(isfinite(m),1));
        if isempty(m)
            msgbox('Cannot plot this');
            return;
        end
        if ~isempty(ui_save_channel_2) && get(ui_save_channel_2,'Value')
            axhandle = obj.extrasignalaxes.get(1).axeshandle;
            plothandles = get(axhandle,'Children');
            m2 = [];
            for i=1:numel(plothandles)
                if strcmpi(get(plothandles(i),'Type'),'line')
                    XData = get(plothandles(i),'XData')';
                    YData = get(plothandles(i),'YData')';
                    if isempty(m2)
                        m2 = nan(nnz(pos),numel(plothandles));
                    elseif nnz(pos)~=size(m2,2)
                        msgbox('Cannot save this type of plot.');
                        return;
                    end
                    m2(:,i) = interp1(XData,YData,m(:,1)); %#ok<AGROW>
                end
            end
            m2 = m2(:,all(isfinite(m2),1));
            m = [m m2];
        end   
        %Convert from s to ms
        m(:,1) = 1e3*m(:,1);
        savename = [get(ui_filename,'String') '.dat'];
        if exist(savename,'file')==2
            answer = questdlg('File exists already. Overwrite?','Overwrite',...
                'Yes','No','Yes');
            if isempty(answer), answer = 'No';  end
            switch answer
                case 'Yes'
                    %do nothing - programmering med både hängslen och
                    %livrem:)
                case 'No'
                    return;
                otherwise
                    error(['debugging error: :' answer])
            end
        end
        dlmwrite(savename,m);
        savenbr = savenbr+1;
        filename = sprintf('%s_%s_signal_%.3i',...
            obj.file.tag, obj.sequence.tag, savenbr);
        set(ui_filename,'String',filename);
        fprintf('Plot saved\n');
    end

%Can be broken up into separate functions, no meaning in having a switch
%case statement any more
    function plot_callback(src,~)
        switch src
            case ui_t_offset
                obj.t_offset = str2double(get(ui_t_offset,'string'));
                obj.sweep = obj.sweep;
            case ui_sweep
                sweep = str2num(get(ui_sweep,'string'));
                obj.sweep = sweep;
            case ui_previous
                incr = str2double(get(ui_increment,'string'));
                sweep = obj.sweep-incr;
                obj.sweep = sweep;
            case ui_next
                incr = str2double(get(ui_increment,'string'));
                sweep = obj.sweep+incr;%str2num(get(ui_sweep,'string'))+incr;
                obj.sweep = sweep;
            case ui_plot_sweep
                obj.sweep = obj.sweep;
            case ui_plot_all
                obj.plot_fcn(1:numel(obj.triggertimes));
            case ui_plot_avg
                obj.plot_fcn(1:numel(obj.triggertimes));
                [v,time] = sc_get_sweeps(obj.v,0, ...
                    obj.triggertimes(1:numel(obj.triggertimes)),obj.pretrigger,...
                    obj.posttrigger,obj.signal.dt);
                plot(obj.signalaxes,time,mean(v,2),'LineWidth',4,'Color',[1 0.6471 0]);
                set(obj.signalaxes,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0],...
                    'Box','off');
                grid(obj.signalaxes,'on');    
            case ui_plot_std   
                cla(obj.signalaxes);
                hold(obj.signalaxes,'on')
                [v,time] = sc_get_sweeps(obj.v,0, ...
                    obj.triggertimes(1:numel(obj.triggertimes)),obj.pretrigger,...
                    obj.posttrigger,obj.signal.dt);
                plot(obj.signalaxes,time,mean(v,2),'LineWidth',4,'Color',[1 0.6471 0]);
                plot(obj.signalaxes,time,mean(v,2)-std(v,1,2),'LineWidth',2,'Color',[1.0000    0.7529    0.7961]);
                plot(obj.signalaxes,time,mean(v,2)+std(v,1,2),'LineWidth',2,'Color',[1.0000    0.7529    0.7961]);
                set(obj.signalaxes,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0],...
                    'Box','off');
                grid(obj.signalaxes,'on');
                xlabel(obj.signalaxes,'Time [s]');
                ylabel(obj.signalaxes,obj.signal.tag);
            otherwise
                error(['debugging error: unknown option: ' src]);
        end
    end


    function zoom_on_callback(~,~)
        obj.zoom_on = ~obj.zoom_on;
    end

    function pan_on_callback(~,~)
        obj.pan_on = ~obj.pan_on;
    end

    function reset_callback(~,~)
        obj.zoom_on = false;
        obj.pan_on = false;
        xlim(obj.signalaxes,[obj.pretrigger obj.posttrigger]);
    end

    function y_zoom_out_callback(~,~)
        yl = get(obj.signalaxes,'ylim');
        set(obj.signalaxes,'ylim',2*yl);
    end

%Add listeners
if obj.state == ScGuiState.spike_detection
    sc_addlistener(obj,'signal_',@signal_listener,panel);
elseif obj.state == ScGuiState.ampl_analysis
    sc_addlistener(obj,'ampl_',@ampl_listener,panel);
end
    function signal_listener(~,~)
        if isempty(obj.signal)
            set(obj.plotpanel,'visible','off');
        else
            set(obj.plotpanel,'visible','on');
        end
    end

    function ampl_listener(~,~)   
        if isempty(obj.ampl)
            set(obj.plotpanel,'visible','off');
        else
            set(obj.plotpanel,'visible','on');
            set(ui_nbr_of_stims,'String',sprintf('(%i)',numel(obj.triggertimes)));
        end
    end

sc_addlistener(obj,'pan_on_',@pan_on_listener,panel);

    function pan_on_listener(~,~)
        if obj.pan_on
            set(ui_pan,'fontweight','bold');
            pan(obj.signalaxes,'on');
        else
            set(ui_pan,'fontweight','normal');
            pan(obj.signalaxes,'off');
        end 
    end

sc_addlistener(obj,'zoom_on_',@zoom_on_listener,panel);

    function zoom_on_listener(~,~)
        if obj.zoom_on
            set(ui_zoom,'fontweight','bold');
            zoom(obj.signalaxes,'on');
        else
            set(ui_zoom,'fontweight','normal');
            zoom(obj.signalaxes,'off');
        end 
    end

sc_addlistener(obj,'trigger_',@trigger_listener,panel);

    function trigger_listener(~,~)
        set(ui_nbr_of_stims,'string',sprintf('(%i)',numel(obj.triggertimes)));
    end

sc_addlistener(obj,'sweep_',@sweep_listener,panel);

    function sweep_listener(~,~)
        if numel(obj.sweep) && numel(obj.triggertimes)
            set(ui_trigger_time,'string',...
                sprintf('trigger time: %0.2f s',obj.triggertimes(obj.sweep(1))),...
                'HorizontalAlignment','left');
            if numel(obj.v)
                set(ui_sweep,'string',num2str(obj.sweep));
                obj.plot_fcn();
            end
        else
            set(ui_trigger_time,'string',[]);
            cla(obj.signalaxes);
        end
    end

end