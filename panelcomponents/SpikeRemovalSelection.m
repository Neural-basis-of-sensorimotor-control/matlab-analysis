classdef SpikeRemovalSelection < PanelComponent
    properties
        ui_list
        ui_add_spike_removal
        ui_delete_spike_removal
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
        end
        function initialize(obj)
            list = obj.gui.main_signal.filter.remove_waveforms;
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
            list = obj.gui.main_signal.filter.remove_waveforms;
            if isempty(obj.gui.waveform)
                msgbox('Cannot add. First choose a waveform');
            else
                if list.contains(obj.gui.waveform);
                    msgbox('Waveform already in list');
                else
                    obj.show_panels(false);
                    list.add(obj.gui.waveform);
                    obj.initialize();
                end
            end
        end
        function delete_spike_removal_callback(obj)
            list = obj.gui.main_signal.filter.remove_waveforms;
            if ~list.n
                msgbox('Cannot remove. List is empty.')
            else
                val = get(obj.ui_list,'value');
                str = get(obj.ui_list,'string');
                list.remove('tag',str{val});
                obj.initialize();
            end
        end
    end
end