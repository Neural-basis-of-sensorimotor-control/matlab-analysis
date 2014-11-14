function modify_threshold(thr, v, startindex, stopindex,varargin)
if nargin<3,    startindex = [];    end
if nargin<4,    stopindex = [];     end

fig = findobj('Tag','Modify Threshold');
if isempty(fig)
    fig = figure('Tag','Modify Threshold');%,'ToolBar','None','MenuBar','None');
else
    fig = fig(1);
end
clf(fig)
if numel(varargin), set(fig,varargin{:});   end
panel = uipanel('Parent',fig);
mgr = ScLayoutManager(panel);
mgr.newline(30);
ui_update = mgr.add(sc_ctrl('pushbutton','Update spikepos',@(~,~) update_spikepos(thr)),100);
ui_plot = mgr.add(sc_ctrl('pushbutton','Update plot',@(~,~) plotv('move_limits',thr)),100);
ui_delete = mgr.add(sc_ctrl('pushbutton','Delete',@(~,~) delete_callback(thr)),80);
ui_add = mgr.add(sc_ctrl('pushbutton','Add',@(~,~) add_callback(thr)),80);
ui_cancel = mgr.add(sc_ctrl('pushbutton','Cancel',@(~,~) cancel_callback(thr),'visible','off'),80);
mgr.add(sc_ctrl('pushbutton','Reset',@reset_callback),80);
mgr.newline(30);
mgr.add(sc_ctrl('text','Index (min):'),100);
ui_startindex = mgr.add(sc_ctrl('edit',startindex,@startindex_callback),80);
mgr.add(sc_ctrl('text','Index (max):'),100);
ui_stopindex = mgr.add(sc_ctrl('edit',startindex,@stopindex_callback),80);
ui_previous = mgr.add(sc_ctrl('pushbutton','Previous',@(~,~) previous_callback(thr)),80);
ui_next = mgr.add(sc_ctrl('pushbutton','Next',@(~,~) next_callback(thr)),80);
mgr.add(sc_ctrl('pushbutton','Close',@close_callback),80);
mgr.trim;

ax = axes('Parent',fig);
resize_fcn();
set(fig,'ResizeFcn',@resize_fcn);

buttongroup = [ui_update, ui_plot, ui_delete, ui_previous, ui_next, ui_add];
spikepos = [];

    function resize_fcn(~,~)
        height = getheight(fig);
        width = getwidth(fig);
        setwidth(panel,width);
        setx(panel,0);
        sety(panel,height-getheight(panel));
        setx(ax,30);
        sety(ax,30);
        axesheight = height-getheight(panel)-45;
        if axesheight>0
            setheight(ax,axesheight);
        end
        axeswidth = width - 45;
        if axeswidth>0
            setwidth(ax,axeswidth);
        end
    end

    function update_spikepos(thr)
        set(buttongroup,'Visible','off');
        set(ax,'visible','off');
        drawnow
        spikepos = thr.match(v,1e-3);
        startindex = 1;
        stopindex = numel(spikepos);
        set(ui_startindex,'string',startindex);
        set(ui_stopindex,'string',stopindex);
        set(buttongroup,'Visible','on');
        set(ax,'visible','on');
        drawnow
    end

    function plotv(state,thr)
        drawnow
        switch state
%             case 'add_limits'
%                 btn_down_fcn = @add_new_limits;
            otherwise
                btn_down_fcn = [];
        end
        spikes = spikepos(max(startindex,1):min(stopindex,numel(spikepos)))';
        cla(ax);
        hold(ax,'on');
        if nnz(spikes)
            colors = varycolor(nnz(spikes));
            pos = bsxfun(@plus,spikes,(0:(8*thr.width))');
            v_matrix = v(pos);
            v_matrix = v_matrix - repmat(v_matrix(1,:),size(v_matrix,1),1);
            t = (0:(size(v_matrix,1)-1))';
            for k=1:size(v_matrix,2)
                plot(ax,t,v_matrix(:,k),'ButtonDownFcn',btn_down_fcn,...
                    'HitTest','off','Color',colors(k,:));
            end
        end
        switch state
            case 'move_limits'
                color = [0 0 1];
                for k=1:numel(thr.position_offset)
                    plot(ax,thr.position_offset(k)*ones(2,1),...
                        thr.v_offset(k)+[thr.lower_tolerance(k); thr.upper_tolerance(k)],...
                        'LineWidth',2,'Color',color,...
                        'ButtonDownFcn',@(src,~) drag_item(k,'bar',src));
                    plot(ax,thr.position_offset(k),thr.v_offset(k)+thr.lower_tolerance(k),...
                        'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                        'ButtonDownFcn',@(src,~) drag_item(k,'lower',src));
                    plot(ax,thr.position_offset(k),thr.v_offset(k)+thr.upper_tolerance(k),...
                        'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                        'ButtonDownFcn',@(src,~) drag_item(k,'upper',src));
                end
            case 'delete_limits'
                color = [0 0 0];
                for k=1:numel(thr.position_offset)
                    plot(ax,thr.position_offset(k)*ones(2,1),...
                        thr.v_offset(k)+[thr.lower_tolerance(k); thr.upper_tolerance(k)],...
                        'LineWidth',2,'Color',color,...
                        'ButtonDownFcn',@(~,~) delete_item(k,thr));
                    plot(ax,thr.position_offset(k),thr.v_offset(k)+thr.lower_tolerance(k),...
                        'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                        'ButtonDownFcn',@(~,~) delete_item(k,thr));
                    plot(ax,thr.position_offset(k),thr.v_offset(k)+thr.upper_tolerance(k),...
                        'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                        'ButtonDownFcn',@(~,~) delete_item(k,thr));
                end
            case 'add_limits'
                color = [0 1 0];
                for k=1:numel(thr.position_offset)
                    plot(ax,thr.position_offset(k)*ones(2,1),...
                        thr.v_offset(k)+[thr.lower_tolerance(k); thr.upper_tolerance(k)],...
                        'LineWidth',2,'Color',color);
                    plot(ax,thr.position_offset(k),thr.v_offset(k)+thr.lower_tolerance(k),...
                        'LineWidth',2,'LineStyle','none','Marker','s','Color',color);
                    plot(ax,thr.position_offset(k),thr.v_offset(k)+thr.upper_tolerance(k),...
                        'LineWidth',2,'LineStyle','none','Marker','s','Color',color);
                end
        end
        switch state
            case 'add_limits'
                set(ax,'ButtonDownFcn',@(~,~) add_new_limits(thr));
                set(fig,'WindowButtonMotionFcn',[],...
                    'WindowButtonUpFcn',[]);
            case 'move_limits'
                set(ax,'ButtonDownFcn',[]);
                set(fig,'WindowButtonMotionFcn',@move_item,...
                    'WindowButtonUpFcn',@(~,~) drop_item(thr));
            case 'delete_limits'
                set(ax,'ButtonDownFcn',[]);
                set(fig,'WindowButtonMotionFcn',[],...
                    'WindowButtonUpFcn',[]);
        end
        item = [];
        item_index = -1;
        item_string = [];
        drawnow
        
        function delete_item(index,thr)
            thr.position_offset(index) = [];
            thr.lower_tolerance(index) = [];
            thr.upper_tolerance(index) = [];
            thr.v_offset(index) = [];
            set(buttongroup,'Visible','on');
            plotv('move_limits',thr);
        end
        
        function drag_item(index,string,src)
            item_index = index;
            item_string = string;
            item = src;
        end
        
        function drop_item(thr)
            if ~isempty(item)
                p = get(ax,'CurrentPoint');
                switch item_string
                    case 'bar'
                        set(item,'XData',round(p(1,1)*[1 1]));
                        thr.position_offset(item_index) = round(p(1,1));
                    case 'lower'
                        set(item,'YData',p(1,2));
                        thr.lower_tolerance(item_index) = p(1,2) - thr.v_offset(item_index);
                    case 'upper'
                        set(item,'YData',p(1,2));
                        thr.upper_tolerance(item_index) = p(1,2) - thr.v_offset(item_index);
                end
                plotv('move_limits',thr);
            end
        end
        
        function move_item(~,~)
            if ~isempty(item)
                p = get(ax,'CurrentPoint');
                switch item_string
                    case 'bar'
                        set(item,'XData',p(1,1)*[1 1]);
                    case {'lower' 'upper'}
                        set(item,'YData',p(1,2));
                end
            end
        end
        
        function add_new_limits(thr)
            drawnow
            p = get(ax,'CurrentPoint');
            n = numel(thr.position_offset)+1;
            thr.position_offset(n) = round(p(1,1));
            thr.v_offset(n) = p(1,2);
            tol = sc_range(ylim(ax))/10;
            thr.lower_tolerance(n) = -tol;
            thr.upper_tolerance(n) = tol;
            plotv('move_limits',thr);
        end
        
    end

    function add_callback(thr)
        set(ui_cancel,'visible','on');
        set(buttongroup,'visible','on');
        plotv('add_limits',thr);
    end

    function delete_callback(thr)
        set(ui_cancel,'visible','on');
        set(buttongroup,'Visible','off');
        plotv('delete_limits',thr);
    end

    function cancel_callback(thr)
        set(ui_cancel,'visible','off');
        set(buttongroup,'Visible','on');
        plotv('move_limits',thr);
    end

    function reset_callback(~,~)
        set(buttongroup,'Visible','on');
    end

    function previous_callback(thr)
        incr = stopindex-startindex+1;
        if startindex>1
            startindex = startindex-incr;
            stopindex = stopindex-incr;
        end
        set(ui_startindex,'string',startindex);
        set(ui_stopindex,'string',stopindex);
        plotv('move_limits',thr);
    end

    function next_callback(thr)
        incr = stopindex-startindex+1;
        if stopindex<numel(v)
            startindex = startindex+incr;
            stopindex = stopindex+incr;
        end
        set(ui_startindex,'string',startindex);
        set(ui_stopindex,'string',stopindex);
        plotv('move_limits',thr);
    end

    function startindex_callback(~,~)
        startindex = str2num(get(ui_startindex,'string'));
        set(ui_startindex,'string',startindex);
    end

    function stopindex_callback(~,~)
        stopindex = str2num(get(ui_stopindex,'string'));
        set(ui_stopindex,'string',stopindex);
    end

    function close_callback(~,~)
        close(fig);
    end

end
