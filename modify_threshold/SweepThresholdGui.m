classdef SweepThresholdGui < GuiFigure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% MISC PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        parent_gui
        triggerpos
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% DEPENDENT PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Dependent, SetAccess = 'private', GetAccess = 'private')
        sweep_nbr
        pretrigger
        posttrigger
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% GUI COMPONENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        ui_sweep_nbr
        ui_pretrigger
        ui_posttrigger
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% PUBLIC METHODS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function obj = SweepThresholdGui(parent_gui,triggerpos)
            obj.parent_gui = parent_gui;
            obj.triggerpos = triggerpos;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% METHODS FROM BASE CLASS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function show(obj,sweepnbr)
            show@GuiFigure(obj);
            obj.sweep_nbr = sweepnbr;
            obj.update_callback();
        end
        function populate(obj,mgr)
            mgr.newline(30);
            mgr.add(sc_ctrl('text','Sweep'),100);
            obj.ui_sweep_nbr = mgr.add(sc_ctrl('edit',1),100);
            mgr.add(sc_ctrl('pushbutton','-',@(~,~) obj.prev_callback),100);
            mgr.add(sc_ctrl('pushbutton','+',@(~,~) obj.next_callback),100);
            mgr.add(sc_ctrl('pushbutton','Update / Reset',@(~,~) obj.update_callback),100);
            mgr.newline(30);
            mgr.add(sc_ctrl('text','Pretrigger (bins)'),100);
            obj.ui_pretrigger = mgr.add(sc_ctrl('edit',-10000),100);
            mgr.add(sc_ctrl('text','Posttrigger (bins)'),100);
            obj.ui_posttrigger = mgr.add(sc_ctrl('edit',10000),100);
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% GUI CALLBACKS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = 'private')
        function prev_callback(obj)
            obj.sweep_nbr = max(obj.sweep_nbr - 1,1);
            obj.update_callback();
        end
        function next_callback(obj)
            obj.sweep_nbr = mod(obj.sweep_nbr + 1,numel(obj.triggerpos));
            obj.update_callback();
        end
        function update_callback(obj)
            cla(obj.ax)
            hold(obj.ax,'on')
            sweep = sc_perieventsweep(obj.parent_gui.v,obj.triggerpos(obj.sweep_nbr),...
                obj.pretrigger,obj.posttrigger);
            spikepos = obj.parent_gui.threshold.match(sweep,1e-3);
            for k=1:length(spikepos)
                plot(obj.ax,spikepos(k),sweep(spikepos(k)),'Linestyle','None',...
                    'Marker','o','MarkerSize',16,'HitTest','off');
            end
            plot(obj.ax,sweep,'color',[135 206 250]/255,'ButtonDownFcn',...
                @(~,~) obj.button_dwn_fcn());
        end
        function button_dwn_fcn(obj)
            p = get(obj.ax,'currentpoint');
            x_ = round(p(1,1));
            y_ = p(1,2);
            thr = obj.parent_gui.threshold;
            for j=1:length(thr.position_offset)
                plot(obj.ax,x_+thr.position_offset(j)*[1 1],...
                    y_+thr.v_offset(j) + [thr.lower_tolerance(j) thr.upper_tolerance(j)],...
                    'color',[0 0 0])
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% SETTERS & GETTERS FOR DEPENDENT PROPERTIES %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods
        function val = get.sweep_nbr(obj)
            val = str2double(get(obj.ui_sweep_nbr,'string'));
        end
        function set.sweep_nbr(obj,val)
            set(obj.ui_sweep_nbr,'string',val);
        end
        function val = get.pretrigger(obj)
            val = str2double(get(obj.ui_pretrigger,'string'));
        end
        function set.pretrigger(obj,val)
            set(obj.ui_pretrigger,'string',val);
        end
        function val = get.posttrigger(obj)
            val = str2double(get(obj.ui_posttrigger,'string'));
        end
        function set.posttrigger(obj,val)
            set(obj.ui_posttrigger,'string',val);
        end
    end
end