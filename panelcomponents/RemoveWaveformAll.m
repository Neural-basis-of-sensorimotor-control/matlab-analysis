classdef RemoveWaveformAll < PanelComponent
    methods
        function obj = RemoveWaveformAll(panel)
            obj@PanelComponent(panel);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            mgr.add(sc_ctrl('pushbutton','Add remove waveform to all (*beta*)',...
                @(~,~) obj.remove_waveform_all_callback()),200);
        end
    end
    methods (Access = 'protected')
        function remove_waveform_all_callback(obj)
            signal = obj.gui.main_signal;
            triggers = obj.gui.file.gettriggers(0,inf);
            if sc_contains(triggers.values('tag'),'1000')
                trigger = triggers.get('tag','1000');
            else
                msgbox('No trigger with tag ''1000''');
                return;
            end
            for k=1:obj.gui.file.n
                seq = obj.gui.file.get(k);
                if ~strcmpi(seq.tag,'full')
                    rmwfs = signal.get_rmwfs(seq.tmin+1,seq.tmax-1);
                    if ~rmwfs.n
                        rmwf = ScRemoveWaveform(signal,trigger,500,false,...
                            seq.tmin,floor(seq.tmax));
                        rmwf.calibrate(obj.gui.main_channel.v);
                        signal.remove_waveforms.add(rmwf);
                    end
                end
            end
        end
    end
end