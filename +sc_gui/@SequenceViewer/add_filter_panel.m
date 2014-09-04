function add_filter_panel(obj)
panel = uipanel('title','Filter','parent',obj.current_view);
mgr = ScLayoutManager(panel);
mgr.newline(15);

%Main channel options
mgr.newline(20);
mgr.add(sc_ctrl('text','Smoothing width'),100);
ui_smoothing_width = mgr.add(sc_ctrl('edit',[],@smoothing_width_callback,...
    'ToolTipString','Smoothing width in bins (1 = off))'),100);
mgr.newline(20);
mgr.add(sc_ctrl('text','Artifact width'),100);
ui_artifact_width = mgr.add(sc_ctrl('edit',[],@artifact_width_callback,'ToolTipString',...
    'Artifact width in bins (0 = off))'),100);

mgr.newline(20);
mgr.add(sc_ctrl('pushbutton','Update',@update_callback),200);

mgr.newline(2);
mgr.trim();

obj.panels.add(panel);

sc_addlistener(obj,'main_signal',@main_signal_listener,panel);
addlistener(panel,'Visible','PostSet',@visible_listener);

%% Callbacks

    function smoothing_width_callback(~,~)
        obj.main_signal.filter.smoothing_width = str2double(get(ui_smoothing_width,'string'));
        obj.disable_panels(panel);
    end

    function artifact_width_callback(~,~)
        obj.main_signal.filter.artifact_width = str2double(get(ui_artifact_width,'string'));
        obj.disable_panels(panel);
    end

    function update_callback(~,~)
        for k=1:obj.plot_axes.n
            ax = obj.plot_axes.get(k);
            if isfield(ax,'signal') &&  ax.signal == obj.main_signal
                ax.update_v(obj.plot_raw);
            end
        end
        obj.enable_panels(panel);
    end

%% Listeners
    function main_signal_listener(~,~)
        set(ui_artifact_width,'string',obj.main_signal.filter.artifact_width);
        set(ui_smoothing_width,'string',obj.main_signal.filter.smoothing_width);
    end

    function visible_listener(~,~)
        visible  = get(panel,'Visible');
        if strcmp(visible,'on')    
            obj.enable_panels(panel);
        else
            obj.disable_panels(panel);
        end
    end
end