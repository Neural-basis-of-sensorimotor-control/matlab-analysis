function initplot(obj,sweeps,btn_down_fcn,plot_wf_shapes)

cla(obj.signalaxes)
xlim(obj.signalaxes,[obj.xmin,obj.xmax]);
hold(obj.signalaxes,'on')
if isempty(sweeps), return; end

if obj.no_trigger
    xl = get(obj.signalaxes,'xlim');
    leftborder = xl(1); rightborder = xl(2);
    plotstart = obj.triggertimes(sweeps(1))+obj.pretrigger;
    plotend = obj.triggertimes(sweeps(1))+obj.posttrigger;
    leftmargin = plotstart - leftborder;
    rightmargin = rightborder - plotend;
    inside = plotend-plotstart;
    if leftmargin/inside > .3 || rightmargin/inside > .3
        set(obj.signalaxes,'xlim',[plotstart plotend]);
    end
end

[v,time] = sc_get_sweeps(obj.v, 0, obj.triggertimes(sweeps), obj.pretrigger, ...
    obj.posttrigger, obj.signal.dt);

if obj.no_trigger && numel(sweeps)
    time = time+obj.triggertimes(obj.sweep(1));
end
if ~isempty(obj.t_offset)
    [~,ind] = min(abs(time-obj.t_offset));
    for i=1:size(v,2)
        v(:,i) = v(:,i) - v(ind,i);
    end
end
if obj.plot_raw
    v_raw = sc_get_sweeps(obj.v_raw, 0, ...
        obj.triggertimes(sweeps),obj.pretrigger,obj.posttrigger,obj.signal.dt);
    if ~isempty(obj.t_offset)
        for i=1:size(v,2)
            v_raw(:,i) = v_raw(:,i) - v_raw(ind,i);
        end
    end
end
xlabel(obj.signalaxes,'Time [s]');
ylabel(obj.signalaxes,obj.signal.tag);
grid(obj.signalaxes,'on')
for i=1:size(v,2)
    if obj.plot_raw
        plot(obj.signalaxes,time,v_raw(:,i),'Color',[0 0 1]);
    end
    plothandle = plot(obj.signalaxes,time,v(:,i),'Color',[1 0 0],'LineWidth',2);
    if ~isempty(btn_down_fcn)
        set(plothandle,'ButtonDownFcn',btn_down_fcn);
    end
    if obj.state == ScGuiState.ampl_analysis && size(v,2)==1
        [~,ind] = min(abs(time));
        text(obj.signalaxes,0,double(v(ind,i)),'start','HorizontalAlignment','center','Color',...
            [0 1 0]);
        triggertime = obj.triggertimes(obj.sweep(1));
        val = obj.ampl.get_data(triggertime,1:4);
        if isfinite(val(1))
            plot(obj.signalaxes,val(1),val(2),'g+','MarkerSize',12,'LineWidth',4);
        end
        if isfinite(val(3))
            plot(obj.signalaxes,val(3),double(val(4)),'b+','MarkerSize',12,'LineWidth',4);
        end
        set(obj.signalaxes,'ButtonDownFcn',@define_amplitude_btndown);
    end
end

    function define_amplitude_btndown(~,~)
        if obj.mouse_press>0
            p = get(obj.signalaxes,'currentpoint');
            t0 = p(1,1); v0 = p(1,2);
            if t0<0
                obj.text = sprintf('You must click to the right of trigger time.\n Awaiting mouse press #%i',obj.mouse_press);
            else
                stimtime = obj.triggertimes(obj.sweep(1));
                obj.ampl.add_data(stimtime,2*obj.mouse_press-[1 0],[t0 v0]);
                obj.has_unsaved_changes = true;
                if obj.mouse_press == 1
                    obj.mouse_press = 2;
                else
                    obj.sweep = obj.sweep + 1;
                end
                obj.plot_fcn();
            end
        end
    end

if plot_wf_shapes
    obj.plot_waveform_shapes_fcn(sweeps,v,btn_down_fcn);
end
set(obj.signalaxes,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0],...
    'Box','off');


end