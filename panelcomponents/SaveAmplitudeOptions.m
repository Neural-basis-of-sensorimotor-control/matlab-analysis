classdef SaveAmplitudeOptions < PanelComponent
    properties
        filenbr = 1
        filename
        ui_filenbr
        ui_filename
        ui_savebutton
    end
    properties (Dependent)
        
    end
    methods
        function obj = SaveAmplitudeOptions(panel)
            obj@PanelComponent(panel);
            obj.sequence_listener();
            sc_addlistener(obj.gui,'sequence',@(~,~) obj.sequence_listener(),obj.uihandle);
        end
        
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_filename = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filename_callback()),150);
            obj.ui_filenbr = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filenbr_callback()),50);
            mgr.newline(20);
            obj.ui_savebutton = mgr.add(sc_ctrl('pushbutton','Save amplitudes to .dat',@(~,~) obj.save_ampl_callback()),200);
        end
        function initialize(obj)
            set(obj.ui_filename,'String',obj.filename);
            set(obj.ui_filenbr,'String',obj.filenbr);
        end
    end
    
    methods (Access = 'protected')
        function sequence_listener(obj)
            if ~isempty(obj.gui.sequence)
                obj.filename = sprintf('%s_%s_ampl_', obj.gui.file.tag, obj.gui.sequence.tag);
                set(obj.ui_filename,'String',obj.filename);
            end
        end
        
        function save_ampl_callback(obj)
            gui = obj.gui;
            pos = all(isfinite(gui.amplitude.data),2);
            latency = gui.amplitude.data(pos,1)*1e3;
            voltage = gui.amplitude.data(pos,4)-gui.amplitude.data(pos,2);
            time_to_peak = 1e3*(gui.amplitude.data(pos,3) - gui.amplitude.data(pos,1));
            savename = sprintf('%s%.3i.dat',obj.filename, obj.filenbr);
            if exist(savename,'file')==2
                answ = questdlg('Filename already exists. Overwrite?');
                if ~isempty(answ) && strcmp(answ,'Yes')
                    fid = fopen(savename,'w');
                    fprintf(fid,'%g,%g,%g\n',[latency voltage time_to_peak]');
                    fclose(fid);
                end
            else
                fid = fopen(savename,'w');
                fprintf(fid,'%g,%g,%g\n',[latency voltage time_to_peak]');
                fclose(fid);
            end
            obj.filenbr = obj.filenbr+1;
            set(obj.ui_filenbr,'string',obj.filenbr);
            fprintf('Plot saved\n');
        end
        function filename_callback(obj)
            obj.filename = get(obj.ui_filename,'string');
        end
        function filenbr_callback(obj)
            obj.filenbr = str2double(get(obj.ui_filenbr,'string'));
        end
    end
end