classdef SaveHistogram < PanelComponent
    properties
        filenbr = 1
        filename
        ui_filename
        ui_filenbr
        ui_save
    end
    methods
        function obj = SaveHistogram(panel)
            obj@PanelComponent(panel);
            obj.sequence_listener();
            sc_addlistener(obj.gui,'sequence',@(~,~) obj.sequence_listener(),obj.uihandle);
        end
        function populate(obj,mgr)
            mgr.newline(20);
            obj.ui_filename = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filename_callback()),150);
            obj.ui_filenbr = mgr.add(sc_ctrl('edit',[],@(~,~) obj.filenbr_callback()),50);
            mgr.newline(20);
            obj.ui_save = mgr.add(sc_ctrl('pushbutton','Save to .dat',@(~,~) obj.save_callback()),200);
        end
        function initialize(obj)
            if isempty(obj.gui.histogram)
                set(obj.children,'Visible','off');
            else
                set(obj.children,'Visible','on');
                set(obj.ui_filename,'string',obj.filename);
                set(obj.ui_filenbr,'string',obj.filenbr);
            end
        end
    end
    methods (Access='protected')
        function sequence_listener(obj)
            if ~isempty(obj.gui.sequence)
                obj.filename = sprintf('%s_%s_hist_',obj.gui.file.tag,obj.gui.sequence.tag);
                set(obj.ui_filename,'String',obj.filename);
            end
        end
        function filename_callback(obj)
            obj.filename = get(obj.ui_filename,'string');
        end
        function filenbr_callback(obj)
            obj.filenbr = str2double(get(obj.ui_filenbr,'string'));
        end
        function save_callback(obj)
            if obj.gui.histogram.hist_type == HistogramType.peristim || ...
                    obj.gui.histogram.hist_type == HistogramType.ISI_pdf || ...
                    obj.gui.histogram.hist_type == HistogramType.continuous
                child = get(obj.gui.histogram.ax,'Children');
            else
                if isempty(obj.gui.rasterplot_window) || ~ishandle(obj.gui.rasterplot_window)
                    obj.gui.histogram.plotch();
                end
                child = get(obj.gui.histogram.rasterplot,'Children');
            end
            if numel(child)~=1
                msgbox('Cannot save this type of plot');
                return
            end
            XData = get(child,'XData')';
            YData = get(child,'YData')';
            c = [1e3*XData YData];
            savename = sprintf('%s%.3i.dat',obj.filename,obj.filenbr);
            if exist(savename,'file')==2
                answer = questdlg('File already exists. Overwrite?','Overwrite',...
                    'Yes','No','Yes');
                if isempty(answer), answer = 'No';  end
                switch answer
                    case 'Yes'
                        %do nothing
                    case 'No'
                        return;
                    otherwise
                        error(['debugging error: command: ' answer]);
                end
            end
            dlmwrite(savename,c);
            obj.filenbr = obj.filenbr + 1;
            set(obj.ui_filenbr,'String',obj.filenbr);
            fprintf('Plot saved\n');
        end
    end
end