classdef WaveformSelection < PanelComponent
    properties
        ui_waveforms
        ui_remove
    end
    methods
        function obj = WaveformSelection(panel)
            obj@PanelComponent(panel);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('text','Waveform'),100);
            obj.ui_waveforms = mgr.add(sc_ctrl('popupmenu',[],@(~,~) obj.show_panels(false),'visible','off'),100);
            mgr.newline(5)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','New waveform',@(~,~) obj.gui.create_new_waveform),100);
            obj.ui_remove = mgr.add(sc_ctrl('pushbutton','Remove waveform',@remove_waveform_callback),100);
            
            sc_addlistener(obj.gui,'waveform',@(~,~) obj.waveform_listener,obj.uihandle);
            
            function remove_waveform_callback(~,~)
                answer = questdlg(sprintf('Are you sure you want to remove all thresholds belonging to waveform %s?',...
                    obj.gui.waveform.tag));
                if strmp(answer,'Yes')
                    obj.gui.main_signal.waveforms.remove(obj.waveform);
                    obj.main_channel.signal = obj.main_signal;
                end
            end
            
        end
        
        function initialize(obj)
            if ~isempty(obj.gui.waveform)
                str = obj.gui.main_signal.waveforms.values('tag');
                ind = find(cellfun(@(x) strcmp(x,obj.gui.waveform.tag), str));
                set(obj.ui_waveforms,'string',str,'value',ind,'visible','on');
            else
                set(obj.ui_waveforms,'visible','off');
            end
        end
        
        function waveform_listener(obj)
            if isempty(obj.gui.waveform)
                set(obj.ui_remove,'enable','off');
            else
                set(obj.ui_remove,'enable','on');
            end
            obj.initialize();
        end
        
        
    end
end