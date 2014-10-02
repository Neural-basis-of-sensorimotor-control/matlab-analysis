classdef ThresholdOptions < PanelComponent
    properties
        ui_define_thresholds
        ui_remove_thresholds
        ui_cancel_thresholds
        ui_undo_last
        ui_added_done
        
        
        endpoint
        endpoint_index = -1
        endpoint_str
        
        t0 = []; v0 = []; tabs = []; vabs = []; lower = []; upper = [];
    end
    
    methods
        function obj = ThresholdOptions(panel)
            obj@PanelComponent(panel);
            sc_addlistener(obj.gui,'waveform',@(~,~) obj.waveform_listener,panel);
            sc_addlistener(obj.gui,'plotmode',@(~,~) obj.plotmode_listener,panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_define_thresholds = mgr.add(sc_ctrl('pushbutton','Add thresholds',...
                @(~,~) obj.define_thresholds_callback),100);
            obj.ui_remove_thresholds = mgr.add(sc_ctrl('pushbutton','Remove thresholds',...
                @(~,~) obj.remove_thresholds_callback),100);
            
            mgr.newline(20);
            obj.ui_cancel_thresholds = mgr.add(sc_ctrl('pushbutton','Cancel',...
                @(~,~) obj.cancel_thresholds_callback,'visible','off'),100);
            
            obj.ui_undo_last = mgr.add(sc_ctrl('pushbutton','Undo last',...
                @(~,~) obj.undo_last_callback,'visible','off'),100);
            
            mgr.newline(20);
            obj.ui_added_done = mgr.add(sc_ctrl('pushbutton','Done',...
                @(~,~) obj.added_done_callback,'Visible','off'),100);
        end
        
        function initialize(obj)
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            set(obj.gui.current_view,'WindowButtonMotionFcn',[]);
            set(obj.gui.current_view,'WindowButtonUpFcn',[]);
            obj.t0 = []; obj.v0 = [];   obj.tabs = []; obj.vabs = []; obj.upper = []; obj.lower = [];
            obj.set_visible(1);
            if ~isempty(obj.gui.waveform) && obj.gui.waveform.n
                set(obj.ui_remove_thresholds,'Visible','on');
            else
                set(obj.ui_remove_thresholds,'Visible','off');
            end
            obj.waveform_listener();
        end
        
    end
    
    methods (Access = 'protected')
        
        function remove_thresholds_callback(obj)
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            obj.set_visible(0);
            obj.remove_threshold_plotfcn();
        end
        
        function define_thresholds_callback(obj)
            obj.dbg_in(mfilename,'define_thresholds_callback');
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            %Reset waveform parameters
            obj.t0 = []; obj.v0 = []; obj.tabs = []; obj.vabs = []; obj.lower = []; obj.upper = [];
            obj.set_visible(0);
            obj.define_threshold_plothandle();
            obj.dbg_out();
        end
        
        function cancel_thresholds_callback(obj)
            obj.initialize();
            obj.gui.plot_channels();
        end
        
        function undo_last_callback(obj)
            if isempty(obj.tabs)
                obj.t0 = [];
                obj.v0 = [];
                obj.set(obj.ui_undo_last,'Visible','off');
                obj.set(obj.ui_added_done,'Visible','off');
            else
                n = numel(obj.tabs);
                obj.tabs = obj.tabs(1:n-1);
                obj.vabs = obj.vabs(1:n-1);
                obj.lower = obj.lower(1:n-1);
                obj.upper = obj.upper(1:n-1);
                set(obj.ui_undo_last,'Visible','on');
            end
            obj.define_threshold_plothandle();
        end
        
        function set_visible(obj,on)
            if on
                visible = 'on';
                set(obj.ui_cancel_thresholds,'Visible','off');
                set(obj.ui_undo_last,'Visible','off');
                set(obj.ui_added_done,'Visible','off');
            else
                visible = 'off';
                set(obj.ui_cancel_thresholds,'Visible','on');
            end
            set(obj.ui_define_thresholds,'Visible',visible);
            if ~isempty(obj.gui.waveform) && obj.gui.waveform.n
                set(obj.ui_remove_thresholds,'Visible',visible);
            else
                set(obj.ui_remove_thresholds,'Visible','off');
            end
        end
        
        function waveform_listener(obj)
            controls = [obj.ui_define_thresholds
                obj.ui_remove_thresholds
                obj.ui_cancel_thresholds
                obj.ui_undo_last
                obj.ui_added_done];
            if isempty(obj.gui.waveform)
                enabledstr = 'off';
            else
                enabledstr = 'on';
            end
            for k=1:numel(controls)
                set(controls(k),'Enable',enabledstr);
            end
        end
        
        function added_done_callback(obj)
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            set(obj.gui.current_view,'WindowButtonMotionFcn',[]);
            set(obj.gui.current_view,'WindowButtonUpFcn',[]);
            threshold = ScThreshold(round((obj.tabs-obj.t0)/obj.gui.main_signal.dt),...
                obj.vabs-obj.v0,obj.lower,obj.upper);
            obj.gui.waveform.add(threshold);
            min_isi = round(obj.gui.waveform.min_isi/obj.gui.main_signal.dt);
            spiketimes = threshold.match_handle(obj.gui.main_channel,min_isi)*obj.gui.main_signal.dt;
            obj.gui.waveform.detected_spiketimes = sort([obj.gui.waveform.detected_spiketimes; spiketimes]);
            obj.gui.has_unsaved_changes = true;
            obj.gui.plot_channels();
            obj.set_visible(1)
        end
        
        function define_threshold_plothandle(obj)
            obj.dbg_in(mfilename,'define_threshold_plothandle');
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            obj.gui.plot_channels(@(~,~) obj.btn_down_fcn_addition);
            
            if ~isempty(obj.t0)
                plot(obj.gui.main_axes,obj.t0,obj.v0,'LineWidth',2,'LineStyle','None',...
                    'Marker','s','Color',[0 0 1]);
            end
            for i=1:numel(obj.tabs)
                plot(obj.gui.main_axes,obj.tabs(i)*[1; 1], obj.vabs(i)+[obj.upper(i); obj.lower(i)],...
                    'LineWidth',2,'Color',[0 0 1]);
                plot(obj.gui.main_axes,obj.tabs(i),obj.vabs(i)+obj.lower(i),'LineWidth',2,'LineStyle','None',...
                    'Marker','s','Color',[0 0 1],'ButtonDownFcn',...
                    @(src,~) obj.drag_endpoint(i,'lower',src));
                plot(obj.gui.main_axes,obj.tabs(i),obj.vabs(i)+obj.upper(i),'LineWidth',2,'LineStyle','None',...
                    'Marker','s','Color',[0 0 1],'ButtonDownFcn',...
                    @(src,~) obj.drag_endpoint(i,'upper',src));
            end
            obj.endpoint = [];
            obj.endpoint_index = -1;
            obj.endpoint_str = [];
            obj.dbg_out();
            
            set(obj.gui.current_view,'WindowButtonMotionFcn',@(~,~) obj.move_endpoint);
            
            set(obj.gui.current_view,'WindowButtonUpFcn',@(~,~) obj.drop_endpoint);
        end
        
        function move_endpoint(obj)
            obj.dbg_in(mfilename,'move_endpoint')
            if ~isempty(obj.endpoint)
                p = get(obj.gui.main_axes,'CurrentPoint');
                set(obj.endpoint,'YData',p(1,2));
            end
            obj.dbg_out();
        end
        
        function drag_endpoint(obj, index,str,src)
            obj.dbg_in(mfilename,'drag_endpoint');
            obj.endpoint = src;
            obj.endpoint_index = index;
            obj.endpoint_str = str;
            obj.dbg_out();
        end
        
        function drop_endpoint(obj)
            obj.dbg_in(mfilename,'drop_endpoint');
            if ~isempty(obj.endpoint)
                p = get(obj.gui.main_axes,'CurrentPoint');
                set(obj.endpoint,'YData',p(1,2));
                obj.endpoint = [];
                switch (obj.endpoint_str)
                    case 'lower'
                        obj.lower(obj.endpoint_index) = p(1,2) - obj.vabs(obj.endpoint_index);
                    case 'upper'
                        obj.upper(obj.endpoint_index) = p(1,2) - obj.vabs(obj.endpoint_index);
                end
                obj.define_threshold_plothandle();
            end
            obj.dbg_out();
        end
        
        function remove_threshold_plotfcn(obj)
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            swps = obj.gui.sweep;
            [v_remove,time_remove] = sc_get_sweeps(obj.gui.main_channel.v,0, ...
                obj.gui.triggertimes(swps),obj.gui.pretrigger,obj.gui.posttrigger,...
                obj.gui.main_signal.dt);
            time_remove = time_remove+obj.gui.triggertimes(obj.gui.sweep(1));
            if ~isempty(obj.gui.set_v_to_zero_for_t )
                [~,ind] = min(abs(time_remove-obj.gui.set_v_to_zero_for_t ));
                for i=1:size(v_remove,2)
                    v_remove(:,i) = v_remove(:,i) - v_remove(ind,i);
                end
            end
            cla(obj.gui.main_axes);
            grid(obj.gui.main_axes,'off');
            hold(obj.gui.main_axes,'on');
            set(obj.gui.main_axes,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0]);
            xlabel(obj.gui.main_axes,'Time [s]');
            ylabel(obj.gui.main_axes,obj.gui.main_signal.tag);
            colors = varycolor(obj.gui.waveform.n+1);
            %Background is black, so all rgb = [0 0 0] -> [1 1 1]
            black = sum(colors,2) < eps;
            colors(black,:) = ones(nnz(black),3);
            for i=1:size(v_remove,2)
                [~,wfindex] = obj.gui.waveform.match(v_remove(:,i));
                plot(obj.gui.main_axes,time_remove,v_remove(:,i),'Color',colors(end,:));
                indexes = unique(wfindex);
                indexes = indexes(indexes>0);
                for j=1:numel(indexes)
                    pos = wfindex == indexes(j);
                    sc_piecewiseplot(obj.gui.main_axes,time_remove(pos),v_remove(pos,i),'Color',...
                        colors(indexes(j),:),'LineWidth',2,'ButtonDownFcn',...
                        @(~,~) obj.btn_down_fcn_removal(indexes(j),wfindex,i,time_remove,...
                        v_remove,colors));
                end
            end
            set(panel,'visible','on');
            set_visible(0);
        end
        
        function btn_down_fcn_removal(obj,index,wfindex,ind,time_remove,v_remove,colors)
            obj.dbg_in(mfilename,'btn_down_fcn_removal');
            sc_piecewiseplot(obj.gui.main_axes,time_remove(wfindex==index),v_remove(wfindex==index,ind),'Color',colors(index,:),...
                'LineWidth',4);
            option = questdlg('Delete highlighted threshold?','Delete',...
                'Yes','Cancel','Yes');
            if isempty(option), option = 'No';  end
            switch option
                case 'Yes'
                    obj.gui.waveform.list(index) = [];
                    obj.gui.waveform.recalculate_spiketimes(obj.gui.main_channel.v,obj.gui.main_signal.dt);
                    obj.gui.has_unsaved_changes = true;
                    if isempty(obj.gui.triggertimes)
                        obj.gui.show();
                        return
                    elseif max(obj.gui.sweep) > numel(obj.gui.triggertimes)
                        obj.gui.sweep = 1;
                    end
                    obj.gui.plot_channels();
                    obj.set_visible(1);
                case 'Cancel'
                    %do nothing
            end
            obj.show_panels(0);
            obj.dbg_out();
        end
        
        function btn_down_fcn_addition(obj)
            obj.dbg_in(mfilename,'btn_down_fcn_addition',1);
            p = get(obj.gui.main_axes,'currentpoint');
            obj.dbg_in(mfilename,'btn_down_fcn_addition',2);
            if isempty(obj.t0)
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3a');
                set(obj.ui_undo_last,'Visible','on');
                obj.t0 = p(1,1);
                obj.v0 = p(1,2);
                obj.dbg_out('3a');
            elseif p(1,1) > obj.t0
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3b');
                set(obj.ui_added_done,'Visible','on');
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3b.1');
                n = numel(obj.tabs);
                obj.dbg_out();
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3b.2');
                obj.tabs(n+1) = p(1,1);
                obj.dbg_out();
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3b.3');
                obj.vabs(n+1) = p(1,2);
                obj.dbg_out();
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3b.4');
                obj.dbg_out();
                if ~n
                    obj.dbg_in(mfilename,'btn_down_fcn_addition','3ba');
                    amplitude = range(get(obj.gui.main_axes,'ylim'))/10;
                    obj.upper(n+1) = amplitude;
                    obj.lower(n+1) = -amplitude;
                    obj.dbg_out('3ba');
                else
                    obj.dbg_in(mfilename,'btn_down_fcn_addition','3bb');
                    obj.upper(n+1) = obj.upper(n);
                    obj.lower(n+1) = obj.lower(n);
                    obj.dbg_out('3bb');
                end
                obj.dbg_out('3b');
            else
                obj.dbg_in(mfilename,'btn_down_fcn_addition','3c');
                obj.dbg_out(2);
                obj.dbg_out(1);
                return
            end
            obj.define_threshold_plothandle();
            obj.dbg_out(2);
            obj.dbg_out(1);
        end
        
        
    end
    
end