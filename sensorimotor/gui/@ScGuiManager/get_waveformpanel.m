function panel = get_waveformpanel(obj)

%Init waveform variables
t0 = []; v0 = []; tabs = []; vabs = []; lower = []; upper = [];

panel = uipanel('title','Waveform');

obj.waveformpanel = panel;
mgr = ScLayoutManager(panel);
mgr.newline(15);

mgr.newline(20);
ui_define_thresholds = mgr.add(uicontrol('style','pushbutton','String',...
    'Add thresholds','Callback',@define_thresholds_callback),100);

ui_cancel_thresholds = mgr.add(uicontrol('style','pushbutton','String',...
    'Cancel','Callback',@cancel_thresholds_callback),100);

ui_undo_last = mgr.add(uicontrol('style','pushbutton','String',...
    'Undo last','Callback',@undo_last_callback),95);

mgr.newline(20);
ui_remove_thresholds = mgr.add(uicontrol('style','pushbutton','String',...
    'Remove thresholds','Callback',@remove_thresholds_callback),100);

ui_added_done = mgr.add(uicontrol('style','pushbutton','String',...
    'Done','Callback',@added_done_callback,'Visible','off'),100);

mgr.newline(2);
mgr.trim;

%Add listeners
sc_addlistener(obj,'waveform',@waveform_listener,panel);

    function waveform_listener(~,~)
        if isempty(obj.waveform)
            set(panel,'visible','off')
        else
            set(panel,'visible','on')
        end
    end

    function added_done_callback(~,~)
        obj.disable_all(1);
        obj.zoom_on = false; obj.pan_on = false;
        set(obj.current_view,'WindowButtonMotionFcn',[]);
        set(obj.current_view,'WindowButtonUpFcn',[]);
        threshold = ScThreshold(round((tabs-t0)/obj.signal.dt),...
            vabs-v0,lower,upper);
        obj.waveform.add(threshold);
        min_isi = round(obj.waveform.min_isi/obj.signal.dt);
        spiketimes = threshold.match_handle(obj,min_isi)*obj.signal.dt;
        obj.waveform.detected_spiketimes = sort([obj.waveform.detected_spiketimes; spiketimes]);
        if obj.plot_waveform_shapes
            t = (0:(numel(obj.v)-1))';
            pos = t >= (round(obj.tmin/obj.signal.dt)+1) & ...
                t < (round(obj.tmax/obj.signal.dt)+1);
            clear t
            [~,wfpos] = threshold.match(obj.v(pos),min_isi);
            obj.wfpos = obj.wfpos | wfpos;
        end
        obj.has_unsaved_changes = true;
        obj.plot_fcn = @obj.default_plot_fcn;
        obj.plot_fcn();
        obj.disable_all(0);
        set_visible(1)
    end

    function remove_thresholds_callback(~,~)
        obj.disable_all(1);
        obj.zoom_on = false; obj.pan_on = false;
        set_visible(0);
        obj.plot_fcn = @remove_threshold_plotfcn;
        obj.plot_fcn();
        obj.disable_all(0);
    end

    function define_thresholds_callback(~,~)
        obj.disable_all(1);
        obj.zoom_on = false; obj.pan_on = false;
        %Reset waveform parameters
        t0 = []; v0 = []; tabs = []; vabs = []; lower = []; upper = [];
        set_visible(0);
        obj.plot_fcn = @define_threshold_plothandle;
        obj.plot_fcn();
        obj.disable_all(0);
    end

    function define_threshold_plothandle
        obj.zoom_on = false; obj.pan_on = false;
        sweep = obj.sweep;
        
        obj.zoom_on = false; obj.pan_on = false;
        obj.plot_stims_fcn(sweep);
        obj.initplot(obj.sweep,@btn_down_fcn,1);
        
        if ~isempty(t0)
            plot(obj.signalaxes,t0,v0,'LineWidth',2,'LineStyle','None',...
                'Marker','s','Color',[0 0 1]);
        end
        for i=1:numel(tabs)
            plot(obj.signalaxes,tabs(i)*[1; 1], vabs(i)+[upper(i); lower(i)],...
                'LineWidth',2,'Color',[0 0 1]);
            plot(obj.signalaxes,tabs(i),vabs(i)+lower(i),'LineWidth',2,'LineStyle','None',...
                'Marker','s','Color',[0 0 1],'ButtonDownFcn',...
                @(src,~) drag_endpoint(i,'lower',src));
            plot(obj.signalaxes,tabs(i),vabs(i)+upper(i),'LineWidth',2,'LineStyle','None',...
                'Marker','s','Color',[0 0 1],'ButtonDownFcn',...
                @(src,~) drag_endpoint(i,'upper',src));
        end
        endpoint = [];
        endpoint_index = -1;
        endpoint_str = [];
        
        function btn_down_fcn(~,~)
            p = get(obj.signalaxes,'currentpoint');
            if isempty(t0)
                set(ui_undo_last,'Visible','on');
                t0 = p(1,1);
                v0 = p(1,2);
            elseif p(1,1) > t0
                set(ui_added_done,'Visible','on');
                n = numel(tabs);
                tabs(n+1) = p(1,1);
                vabs(n+1) = p(1,2);
                if ~n
                    amplitude = range(get(obj.signalaxes,'ylim'))/10;
                    upper(n+1) = amplitude;
                    lower(n+1) = -amplitude;
                else
                    upper(n+1) = upper(n);
                    lower(n+1) = lower(n);
                end
            else
                return
            end
            obj.plot_fcn();
        end
        
        function drag_endpoint(index,str,src)
            endpoint = src;
            endpoint_index = index;
            endpoint_str = str;
        end
        
        set(obj.current_view,'WindowButtonMotionFcn',@move_endpoint);
        
        function move_endpoint(~,~)
            if ~isempty(endpoint)
                p = get(obj.signalaxes,'CurrentPoint');
                set(endpoint,'YData',p(1,2));
            end
        end
        
        set(obj.current_view,'WindowButtonUpFcn',@drop_endpoint);
        
        function drop_endpoint(~,~)
            if ~isempty(endpoint)
                p = get(obj.signalaxes,'CurrentPoint');
                set(endpoint,'YData',p(1,2));
                endpoint = [];
                switch (endpoint_str)
                    case 'lower'
                        lower(endpoint_index) = p(1,2) - vabs(endpoint_index);
                    case 'upper'
                        upper(endpoint_index) = p(1,2) - vabs(endpoint_index);
                    otherwise
                        error(['debug error:  unknown option: ' endpoint_str])
                end
                obj.plot_fcn();
            end
        end
    end

    function cancel_thresholds_callback(~,~)
        obj.zoom_on = false; obj.pan_on = false;
        set(obj.current_view,'WindowButtonMotionFcn',[]);
        set(obj.current_view,'WindowButtonUpFcn',[]);
        t0 = []; v0 = [];   tabs = []; vabs = []; upper = []; lower = [];
        set_visible(1);
        obj.plot_fcn = @obj.default_plot_fcn;
        obj.plot_fcn();
    end

    function undo_last_callback(~,~)
        if isempty(tabs)
            t0 = [];
            v0 = [];
            set(ui_undo_last,'Visible','off');
            set(ui_added_done,'Visible','off');
        else
            n = numel(tabs);
            tabs = tabs(1:n-1);
            vabs = vabs(1:n-1);
            lower = lower(1:n-1);
            upper = upper(1:n-1);
            set(ui_undo_last,'Visible','on');
        end
        obj.plot_fcn();
    end

    function remove_threshold_plotfcn(~)    
        obj.disable_all(1);
        obj.zoom_on = false; obj.pan_on = false;
        swps = obj.sweep;
        [v_remove,time_remove] = sc_get_sweeps(obj.v,0, ...
            obj.triggertimes(swps),obj.pretrigger,obj.posttrigger,obj.signal.dt);
        if obj.no_trigger && numel(swps)
            time_remove = time_remove+obj.triggertimes(obj.sweep(1));
        end
        if ~isempty(obj.t_offset)
            [~,ind] = min(abs(time_remove-obj.t_offset));
            for i=1:size(v_remove,2)
                v_remove(:,i) = v_remove(:,i) - v_remove(ind,i);
            end
        end
        cla(obj.signalaxes);
        grid(obj.signalaxes,'off');
        hold(obj.signalaxes,'on');
        set(obj.signalaxes,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0]);
        xlabel(obj.signalaxes,'Time [s]');
        ylabel(obj.signalaxes,obj.signal.tag);
        colors = varycolor(obj.waveform.n+1);
        %Background i black, so all rgb = [0 0 0] -> [1 1 1]
        black = sum(colors,2) < eps;
        colors(black,:) = ones(nnz(black),3);
        for i=1:size(v_remove,2)
            [~,wfindex] = obj.waveform.match(v_remove(:,i));
            plot(obj.signalaxes,time_remove,v_remove(:,i),'Color',colors(end,:));
            indexes = unique(wfindex);
            indexes = indexes(indexes>0);
            for j=1:numel(indexes)
                pos = wfindex == indexes(j);
                sc_piecewiseplot(obj.signalaxes,time_remove(pos),v_remove(pos,i),'Color',...
                    colors(indexes(j),:),'LineWidth',2,'ButtonDownFcn',...
                    @(~,~) btn_down_fcn(indexes(j),wfindex,i,time_remove,...
                    v_remove));
            end
        end
        
        cla(obj.stimaxes);
        set(obj.stimaxes,'Color',[0 0 0]);
        for i=1:obj.extrasignalaxes.n
            axhandle = obj.extrasignalaxes.get(i).axeshandle;
            cla(axhandle);
            set(axhandle,'Color',[0 0 0]);
        end
        cla(obj.histogramaxes);
        obj.disable_all(0);
        
        function btn_down_fcn(index,wfindex,ind,time_remove,v_remove)
            obj.disable_all(1);
            sc_piecewiseplot(obj.signalaxes,time_remove(wfindex==index),v_remove(wfindex==index,ind),'Color',colors(index,:),...
                'LineWidth',4);
            option = questdlg('Delete highlighted threshold?','Delete',...
                'Yes','Cancel','Yes');
            if isempty(option), option = 'No';  end
            switch option
                case 'Yes'
                    obj.waveform.list(index) = [];
                    obj.waveform.recalculate_spiketimes(obj.v,obj.signal.dt);
                    obj.has_unsaved_changes = true;
                    obj.plot_fcn = @obj.default_plot_fcn;
                    obj.plot_fcn();
                    set_visible(1);
                    set(obj.plotpanel,'Visible','off');
                    set(obj.waveformpanel,'Visible','off');
                    set(obj.filepanel,'Visible','on');
                    set(obj.triggerpanel,'Visible','on');
                case 'Cancel'
                    %do nothing
                otherwise
                    error(['Unknown option ' option])
            end
            obj.disable_all(0);
        end
    end

    function set_visible(on)
        if on
            visible = 'on';
            set(ui_cancel_thresholds,'Visible','off');
            set(ui_undo_last,'Visible','off');
            set(ui_added_done,'Visible','off');
        else
            visible = 'off';
            set(ui_cancel_thresholds,'Visible','on');
        end
        %set(h.filepanel,'Visible',visible);
        set(obj.triggerpanel,'Visible',visible);
        set(obj.histogrampanel,'Visible',visible);
        set(ui_define_thresholds,'Visible',visible);
        if ~isempty(obj.waveform) && obj.waveform.n
            set(ui_remove_thresholds,'Visible',visible);
        else
            set(ui_remove_thresholds,'Visible','off');
        end
    end
end