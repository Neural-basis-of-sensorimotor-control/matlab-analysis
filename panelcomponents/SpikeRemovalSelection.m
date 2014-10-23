classdef SpikeRemovalSelection < PanelComponent
    properties
        ui_list
        ui_add_spike_removal
        ui_delete_spike_removal
        ui_update_spike_removal
    end
    methods
        function obj = SpikeRemovalSelection(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Spike removal tool'),100);
            obj.ui_list = mgr.add(sc_ctrl('popupmenu',[],[],'visible','off'),100);
            mgr.newline(5);
            mgr.newline(20);
            obj.ui_add_spike_removal = mgr.add(sc_ctrl('pushbutton','Add to spike removal list',@(~,~) obj.add_to_spike_removal_callback),200);
            mgr.newline(20);
            obj.ui_delete_spike_removal = mgr.add(sc_ctrl('pushbutton','Delete from spike removal list',@(~,~) obj.delete_spike_removal_callback),200);
            mgr.newline(20);
            obj.ui_update_spike_removal = mgr.add(sc_ctrl('pushbutton','Update spike removal times',@(~,~) obj.update_spike_removal_callback),200);
        end
        function initialize(obj)
            list = obj.gui.main_signal.remove_waveforms;
            if list.n
                set(obj.ui_list,'string',list.values('tag'));
                set(obj.ui_list,'value',1);
                set(obj.ui_list,'visible','on');
            else
                set(obj.ui_list,'visible','off');
            end
        end
    end
    methods (Access='protected')
        function add_to_spike_removal_callback(obj)
            list = obj.gui.main_signal.remove_waveforms;
            if isempty(obj.gui.waveform)
                msgbox('Cannot add. First choose a waveform');
            else
                str = list.values('tag');
                if sc_contains(str,obj.gui.waveform.tag);
                    msgbox('Waveform with same name already in list');
                else
                    obj.gui.lock_screen(true,'Wait, calibrating waveform position...');
                    obj.gui.has_unsaved_changes = true;
                    obj.gui.main_channel.load_data();
                    obj.show_panels(false);
                    rmwf = ScRemoveWaveform(obj.gui.waveform);
                    rmwf.calibrate(obj.gui.main_channel.v);
                    list.add(rmwf);
                    obj.initialize();
                    obj.gui.lock_screen(false);
                end
            end
        end
        function delete_spike_removal_callback(obj)
            list = obj.gui.main_signal.remove_waveforms;
            if ~list.n
                msgbox('Cannot remove. List is empty.')
            else
                obj.gui.has_unsaved_changes = true;
                val = get(obj.ui_list,'value');
                str = get(obj.ui_list,'string');
                list.remove('tag',str{val});
                obj.initialize();
            end
        end
        function update_spike_removal_callback(obj)
            obj.gui.has_unsaved_changes = true;
            obj.gui.lock_screen(true,'Wait, updating spike removal tool...');
            obj.gui.main_channel.load_data(false);
            list = obj.gui.main_signal.remove_waveforms;
            for k=1:list.n
                list.get(k).update_waveform(obj.gui.main_channel.v);
            end
            obj.gui.lock_screen(false);
        end
    end
end