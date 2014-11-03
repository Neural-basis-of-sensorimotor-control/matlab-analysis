classdef WaveformSelection < PanelComponent
    properties
        ui_waveforms
        ui_remove
%         ui_waveform_order
        ui_nbr_of_spikes
    end
    methods
        function obj = WaveformSelection(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Waveform'),100);
            obj.ui_waveforms = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.waveform_callback(),'visible','off'),100);
            mgr.newline(5)
%             mgr.newline(20);
%             mgr.add(sc_ctrl('text','Waveform order:'),100);
%             obj.ui_waveform_order = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.waveform_order_callback(),'visible','off'),100);
%             mgr.newline(5)
            mgr.newline(20);
            obj.ui_nbr_of_spikes = mgr.add(sc_ctrl('text',[]),200);
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','New waveform',@add_waveform_callback),100);
            obj.ui_remove = mgr.add(sc_ctrl('pushbutton','Remove waveform',@remove_waveform_callback),100);
            mgr.newline(20)
            mgr.add(sc_ctrl('pushbutton','Detect all waveforms again',@(~,~) obj.update_all_waveforms),200);
                        
            sc_addlistener(obj.gui,'waveform',@(~,~) obj.waveform_listener,obj.uihandle);
            
            function add_waveform_callback(~,~)
                obj.gui.create_new_waveform;
                obj.show_panels(false);
            end
            
            function remove_waveform_callback(~,~)
                if isempty(obj.gui.waveform)
                    msgbox('No waveform selected. Cannot remove');
                else
                    answer = questdlg(sprintf('Are you sure you want to remove all thresholds belonging to waveform %s?',...
                        obj.gui.waveform.tag));
                    if strcmp(answer,'Yes')
                        prev_index = obj.gui.panels.indexof(obj.panel)-1;
                        prev_panel = obj.gui.panels.get(prev_index);
                        obj.gui.disable_panels(prev_panel);
                        obj.gui.main_signal.waveforms.remove(obj.gui.waveform);
                        obj.gui.main_channel.signal = obj.gui.main_signal;
                        obj.gui.has_unsaved_changes = true;
                        obj.show_panels(false);
                    end
                end
            end
        end
        
        function initialize(obj)
            if isempty(obj.gui.waveform) && obj.gui.main_signal.waveforms.n
                obj.gui.waveform = obj.gui.main_signal.waveforms.get(1);
            end
            if ~isempty(obj.gui.waveform)
                wf = obj.gui.waveform;
                str = obj.gui.main_signal.waveforms.values('tag');
                ind = find(cellfun(@(x) strcmp(x,wf.tag), str));
                set(obj.ui_waveforms,'string',str,'value',ind,'visible','on');
                %[enum,enum_str] = enumeration('ScWaveformEnum');
                %set(obj.ui_waveform_order,'string',enum_str,'value',find(enum==wf.apply_after),'visible','on');
                set(obj.ui_nbr_of_spikes,'string',sprintf('Number of spikes in this sequence: %i',numel(obj.gui.waveform.gettimes(obj.gui.sequence.tmin,obj.gui.sequence.tmax))));
            else
                set(obj.ui_waveforms,'visible','off');
            end
        end
        
        function waveform_listener(obj)
            if isempty(obj.gui.waveform)
                set(obj.ui_remove,'enable','off');
            else
                set(obj.ui_remove,'enable','on');
                set(obj.ui_nbr_of_spikes,'string',sprintf('Number of spikes in this sequence: %i',numel(obj.gui.waveform.gettimes(obj.gui.sequence.tmin,obj.gui.sequence.tmax))));
            end
            obj.initialize();
        end
        
    end
    
    methods (Access = 'protected')
        function waveform_callback(obj)
            str = get(obj.ui_waveforms,'string');
            val = get(obj.ui_waveforms,'value');
            obj.gui.waveform = obj.gui.main_signal.waveforms.get('tag',str{val});
            obj.show_panels(false);
        end
%         function waveform_order_callback(obj)
%             str = get(obj.ui_waveform_order,'string');
%             val = get(obj.ui_waveform_order,'value');
%             [enum,enum_str] = enumeration('ScWaveformEnum');
%             obj.gui.waveform.apply_after = enum(sc_cellfind(enum_str,str{val}));
%             obj.gui.has_unsaved_changes = true;
%         end
        function update_all_waveforms(obj)
            obj.gui.lock_screen(true,'Recalculating all waveforms, might take a minute...');
            obj.show_panels(false);
            obj.gui.has_unsaved_changes = true;
            obj.gui.main_channel.signal.recalculate_all_waveforms();
            obj.gui.lock_screen(false);
        end
    end
end