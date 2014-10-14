classdef ManualSpikeTimes < PanelComponent
    properties
        ui_add
        ui_remove
        plothandles
    end
    methods
        function obj = ManualSpikeTimes(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_add = mgr.add(sc_ctrl('pushbutton','Add spiketime manually',@(~,~) obj.add_spiketime_callback()),200);
            mgr.newline(20);
            obj.ui_remove = mgr.add(sc_ctrl('pushbutton','Remove manual spiketime',@(~,~) obj.remove_spiketime_callback()),200);
     %       sc_addlistener(obj.gui,'waveform',@(~,~) obj.waveform_listener,obj.ui_add);
        end
%         function initialize(obj)
%             obj.waveform_listener();
%         end
    end
    methods (Access='protected')
        function add_spiketime_callback(obj)
            if isempty(obj.gui.waveform)
                msgbox('No waveform selected');
            else
                obj.gui.lock_screen(true,'Click in figure at the start of leading flank of spike');
                obj.plot_signal();
                set(obj.ui_remove,'string','Done','callback',@(~,~) obj.done_callback(),'Enable','on');
            end
        end
        function btn_down_fcn(obj,index)
            p = get(obj.gui.main_axes,'currentpoint');
            t = p(1,1) + obj.gui.triggertimes(obj.gui.sweep(index));
            obj.gui.waveform.predefined_spiketimes = sort([obj.gui.waveform.predefined_spiketimes; t]);
            obj.gui.has_unsaved_changes = true;
            obj.gui.plot_channels();
            obj.plot_signal();
        end
        function plot_signal(obj)
            obj.gui.zoom_on = false; obj.gui.pan_on = false;
            swps = obj.gui.sweep;
            [v,time] = sc_get_sweeps(obj.gui.main_channel.v,0, ...
                obj.gui.triggertimes(swps),obj.gui.pretrigger,obj.gui.posttrigger,...
                obj.gui.main_signal.dt);
            if ~isempty(obj.gui.main_channel.v_equals_zero_for_t )
                [~,ind] = min(abs(time-obj.gui.main_channel.v_equals_zero_for_t ));
                for i=1:size(v,2)
                    v(:,i) = v(:,i) - v(ind,i);
                end
            end
            cla(obj.gui.main_axes);
            grid(obj.gui.main_axes,'off');
            hold(obj.gui.main_axes,'on');
            set(obj.gui.main_axes,'XColor',[1 1 1],'YColor',[1 1 1],'Color',[0 0 0]);
            xlabel(obj.gui.main_axes,'Time [s]');
            ylabel(obj.gui.main_axes,obj.gui.main_signal.tag);
            for i=1:size(v,2)
                plot(obj.gui.main_axes,time,v(:,i),'Color',[1 0 0],'ButtonDownFcn',...
                    @(~,~) obj.btn_down_fcn(i));
            end
        end
        function done_callback(obj)
            obj.gui.lock_screen(false);
            set(obj.ui_remove,'string','Remove manual spiketime','callback',@(~,~) obj.remove_spiketime_callback(),'Enable','on');
            obj.gui.plot_channels();
        end
        function remove_spiketime_callback(obj)
            if isempty(obj.gui.digital_channels)
                msgbox('In order to remove manually added spiketimes, ''Show digital channels'' option must be enabled');
            elseif isempty(obj.gui.waveform)
                msgbox('No waveform selected');
            elseif numel(obj.gui.sweep)~=1
                msgbox('Only one sweep at the time possible to remove manual spiketimes');
            else
                obj.gui.lock_screen(true,'Click on digital axes for waveform to be deleted');
                obj.gui.digital_channels.plotch(@(~,~) obj.remove_spike_btn_down);
            end
        end
        function remove_spike_btn_down(obj)
            p = get(obj.gui.digital_channels,'currentpoint');
            t = p(1,1) + obj.gui.triggertimes(obj.gui.sweep);
            if isempty(obj.gui.waveform.predefined_spiketimes)
                msgbox('Could not delete: No click-defined spiketimes for current sweep(s).')
            else
                [~,ind] = min(abs(obj.gui.waveform.predefined_spiketimes-t));
                obj.gui.waveform.predefined_spiketimes(ind) = [];
                obj.gui.help_text = 'Spike removed';
                obj.remove_spiketime_callback();
            end
        end
    end
end