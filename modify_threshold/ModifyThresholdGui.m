classdef ModifyThresholdGui < GuiFigure
    methods (Static)
        function modify(threshold,v,triggerpos,sweepnbr)
            m = ModifyThresholdGui(threshold,v,triggerpos,sweepnbr);
            m.show();
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% MISC PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        has_unsaved_changes
        sweep_gui
        
        original_threshold
        threshold
        v
        
        spikepos
        sweepnbr
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% GUI COMPONENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        item
        item_index
        item_string
        
        ui_reset
        ui_imin
        ui_imax
        ui_itot
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% DEPENDENT PROPERTIES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Dependent)
        btns
        startindex
        stopindex
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% PUBLIC METHODS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function obj = ModifyThresholdGui(threshold,v,triggerpos,sweepnbr)
            obj@GuiFigure();
            obj.has_unsaved_changes = false;
            obj.original_threshold = threshold;
            obj.threshold = threshold.create_copy();
            obj.v = v;
            obj.sweep_gui = SweepThresholdGui(obj,round(triggerpos));
            obj.sweepnbr = sweepnbr;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% DEPEDENT PROPERTY SETTERS & GETTERS %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function startindex = get.startindex(obj)
            startindex = str2double(get(obj.ui_imin,'string'));
        end
        function stopindex = get.stopindex(obj)
            stopindex = str2double(get(obj.ui_imax,'string'));
        end
        function btns = get.btns(obj)
            btns = get(obj.panel,'children');
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% GUI CALLBACKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = 'private')
        function detect_spikepos_callback(obj)
            set(obj.btns,'Enable','off');
            set(obj.ax,'Visible','off');
            set(obj.ui_reset,'Enable','on');
            drawnow
            obj.spikepos = obj.threshold.match_v(obj.v);
            if ~isempty(obj.spikepos)
                set(obj.ui_imin,'string',1);
                set(obj.ui_imax,'string',min(100,length(obj.spikepos)));
            else
                set(obj.ui_imin,'string',[]);
                set(obj.ui_imax,'string',[]);
            end
            set(obj.ui_itot,'string',sprintf('# of spikes: %i',length(obj.spikepos)));
            set(obj.ax,'Visible','on');
            set(obj.btns,'Enable','on');
            obj.plotch();
            drawnow
        end
        function add_limit_callback(obj)
            obj.plotch();
            color = [0 1 0];
            for k=1:numel(obj.threshold.position_offset)
                plot(obj.ax,obj.threshold.position_offset(k)*ones(2,1),...
                    obj.threshold.v_offset(k)+[obj.threshold.lower_tolerance(k); obj.threshold.upper_tolerance(k)],...
                    'LineWidth',2,'Color',color);
                plot(obj.ax,obj.threshold.position_offset(k),obj.threshold.v_offset(k)+obj.threshold.lower_tolerance(k),...
                    'LineWidth',2,'LineStyle','none','Marker','s','Color',color);
                plot(obj.ax,obj.threshold.position_offset(k),obj.threshold.v_offset(k)+obj.threshold.upper_tolerance(k),...
                    'LineWidth',2,'LineStyle','none','Marker','s','Color',color);
            end
            set(obj.ax,'ButtonDownFcn',@(~,~) obj.add_new_limit());
            set(obj.window,'WindowButtonMotionFcn',[],...
                'WindowButtonUpFcn',[]);
        end
        function delete_limit_callback(obj)
            color = [0 0 0];
            for k=1:numel(obj.threshold.position_offset)
                plot(obj.ax,obj.threshold.position_offset(k)*ones(2,1),...
                    obj.threshold.v_offset(k)+[obj.threshold.lower_tolerance(k); obj.threshold.upper_tolerance(k)],...
                    'LineWidth',2,'Color',color,...
                    'ButtonDownFcn',@(~,~) obj.delete_item(k));
                plot(obj.ax,obj.threshold.position_offset(k),obj.threshold.v_offset(k)+obj.threshold.lower_tolerance(k),...
                    'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                    'ButtonDownFcn',@(~,~) obj.delete_item(k));
                plot(obj.ax,obj.threshold.position_offset(k),obj.threshold.v_offset(k)+obj.threshold.upper_tolerance(k),...
                    'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                    'ButtonDownFcn',@(~,~) obj.delete_item(k));
            end
            set(obj.ax,'ButtonDownFcn',[]);
            set(obj.window,'WindowButtonMotionFcn',[],...
                'WindowButtonUpFcn',[]);
        end
        function reset_callback(obj)
            set(obj.btns,'Enable','on');
            set(obj.ui_reset,'Enable','off');
            set(obj.ax,'Visible','on');
            obj.move_limit();
        end
        function previous_callback(obj)
            start = obj.startindex;
            stop = obj.stopindex;
            incr = stop-start+1;
            if start>1
                start = obj.startindex-incr;
                stop = obj.stopindex-incr;
            end
            set(obj.ui_imin,'string',start);
            set(obj.ui_imax,'string',stop);
            obj.move_limit();
        end
        function next_callback(obj)
            start = obj.startindex;
            stop = obj.stopindex;
            incr = stop-start+1;
            if stop<numel(obj.v)
                start = start+incr;
                stop = stop+incr;
            end
            set(obj.ui_imin,'string',start);
            set(obj.ui_imax,'string',stop);
            obj.move_limit();
        end
        function startindex_callback(~,~)
            startindex = str2double(get(ui_startindex,'string'));
            set(ui_startindex,'string',startindex);
        end
        function stopindex_callback(~,~)
            stopindex = str2double(get(ui_stopindex,'string'));
            set(ui_stopindex,'string',stopindex);
        end
        function update_callback(obj)
            obj.move_limit();
        end
        function show_sweep_callback(obj)
            obj.sweep_gui.show(obj.sweepnbr);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% GUI SUB-ROUTINES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = 'private')
        function add_new_limit(obj)
            p = get(obj.ax,'CurrentPoint');
            n = numel(obj.threshold.position_offset)+1;
            obj.threshold.position_offset(n) = round(p(1,1));
            obj.threshold.v_offset(n) = p(1,2);
            tol = sc_range(ylim(obj.ax))/10;
            obj.threshold.lower_tolerance(n) = -tol;
            obj.threshold.upper_tolerance(n) = tol;
            obj.has_unsaved_changes = true;
            obj.move_limit();
        end
        function delete_item(obj,index)
            obj.threshold.position_offset(index) = [];
            obj.threshold.lower_tolerance(index) = [];
            obj.threshold.upper_tolerance(index) = [];
            obj.threshold.v_offset(index) = [];
            obj.has_unsaved_changes = true;
            obj.move_limit();
        end
        function plotch(obj)
            zoom(obj.window,'off');
            pan(obj.ax,'off');
            startindex = str2double(get(obj.ui_imin,'string'));
            stopindex = str2double(get(obj.ui_imax,'string'));
            spikes = obj.spikepos(max(startindex,1):min(stopindex,numel(obj.spikepos)))';
            cla(obj.ax);
            hold(obj.ax,'on');
            if nnz(spikes)
                colors = varycolor(nnz(spikes));
                pos = bsxfun(@plus,spikes,(0:(8*obj.threshold.width))');
                within_boundary = all(pos<=numel(obj.v),1);
                pos = pos(:,within_boundary);
                v_matrix = obj.v(pos);
                v_matrix = v_matrix - repmat(v_matrix(1,:),size(v_matrix,1),1);
                t = (0:(size(v_matrix,1)-1))';
                for k=1:size(v_matrix,2)
                    plot(obj.ax,t,v_matrix(:,k),'HitTest','off','Color',colors(k,:));
                end
            end
        end
        function move_limit(obj)
            obj.plotch();
            color = [0 0 1];
            for k=1:numel(obj.threshold.position_offset)
                plot(obj.ax,obj.threshold.position_offset(k)*ones(2,1),...
                    obj.threshold.v_offset(k)+[obj.threshold.lower_tolerance(k); obj.threshold.upper_tolerance(k)],...
                    'LineWidth',2,'Color',color,...
                    'ButtonDownFcn',@(src,~) obj.drag_item(k,'bar',src));
                plot(obj.ax,obj.threshold.position_offset(k),obj.threshold.v_offset(k)+obj.threshold.lower_tolerance(k),...
                    'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                    'ButtonDownFcn',@(src,~) obj.drag_item(k,'lower',src));
                plot(obj.ax,obj.threshold.position_offset(k),obj.threshold.v_offset(k)+obj.threshold.upper_tolerance(k),...
                    'LineWidth',2,'LineStyle','none','Marker','s','Color',color,...
                    'ButtonDownFcn',@(src,~) obj.drag_item(k,'upper',src));
            end
            set(obj.ax,'ButtonDownFcn',[]);
            set(obj.window,'WindowButtonMotionFcn',@(~,~) obj.move_item,...
                'WindowButtonUpFcn',@(~,~) obj.drop_item);
            obj.item = [];
            obj.item_index = -1;
            obj.item_string = [];
        end
        function drag_item(obj,index,string,src)
            obj.item_index = index;
            obj.item_string = string;
            obj.item = src;
        end
        function drop_item(obj)
            if ~isempty(obj.item)
                p = get(obj.ax,'CurrentPoint');
                switch obj.item_string
                    case 'bar'
                        set(obj.item,'XData',round(p(1,1)*[1 1]));
                        obj.threshold.position_offset(obj.item_index) = round(p(1,1));
                    case 'lower'
                        set(obj.item,'YData',p(1,2));
                        obj.threshold.lower_tolerance(obj.item_index) = p(1,2) - obj.threshold.v_offset(obj.item_index);
                    case 'upper'
                        set(obj.item,'YData',p(1,2));
                        obj.threshold.upper_tolerance(obj.item_index) = p(1,2) - obj.threshold.v_offset(obj.item_index);
                end
                obj.has_unsaved_changes = true;
                obj.move_limit();
            end
        end
        function move_item(obj)
            if ~isempty(obj.item)
                p = get(obj.ax,'CurrentPoint');
                switch obj.item_string
                    case 'bar'
                        set(obj.item,'XData',p(1,1)*[1 1]);
                    case {'lower' 'upper'}
                        set(obj.item,'YData',p(1,2));
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% METHODS FROM BASE CLASS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods 
        function show(obj)
            show@GuiFigure(obj);
            obj.sweep_gui.show(obj.sweepnbr);
            figure(obj.window);
        end
        function populate(obj,mgr)
            mgr.newline(30);
            mgr.add(sc_ctrl('pushbutton','Compute spiketimes',...
                @(~,~) obj.detect_spikepos_callback()),100);
            mgr.add(sc_ctrl('pushbutton','Add limit',...
                @(~,~) obj.add_limit_callback()),100);
            mgr.add(sc_ctrl('pushbutton','Delete limit',...
                @(~,~) obj.delete_limit_callback()),100);
            obj.ui_reset = mgr.add(sc_ctrl('pushbutton','Reset',...
                @(~,~) obj.reset_callback()),100);
            mgr.newline(30);
            mgr.add(sc_ctrl('text','min index'),100);
            obj.ui_imin = mgr.add(sc_ctrl('edit'),100);
            mgr.add(sc_ctrl('text','max index'),100);
            obj.ui_imax = mgr.add(sc_ctrl('edit'),100);
            obj.ui_itot = mgr.add(sc_ctrl('text',''),100);
            mgr.add(sc_ctrl('pushbutton','-',@(~,~) obj.previous_callback),100);
            mgr.add(sc_ctrl('pushbutton','+',@(~,~) obj.next_callback),100);
            mgr.newline(30);
            mgr.add(sc_ctrl('pushbutton','Update',@(~,~) obj.update_callback),100);
            mgr.add(sc_ctrl('pushbutton','Show sweep',@(~,~) obj.show_sweep_callback),100);
        end
        function window = get_window(obj)
            window = get_window@GuiFigure(obj);
            set(obj.window,'CloseRequestFcn',@(~,~) obj.close_request());
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% FIGURE CALLBACKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function close_request(obj)
            if obj.has_unsaved_changes
                answ = questdlg('Threshold has changed. Apply changes?');
                if isempty(answ)
                    answ = 'Cancel';
                end
                switch answ
                    case 'Yes'
                        obj.original_threshold = obj.threshold.create_copy();
                        delete(obj.window);
                        close(obj.sweep_gui.get_window());
                    case 'No'
                        delete(obj.window);
                        close(obj.sweep_gui.get_window());
                end
            else
                delete(obj.window);
                close(obj.sweep_gui.get_window());
            end
        end
    end
end