function close_request(obj)
if obj.has_unsaved_changes
    option = questdlg('There are unsaved changes. Save before closing?',...
        'Close Request Function',...
        'Yes','No, close without saving','Cancel','Yes');
    if isempty(option), option = 'Cancel';  end
    switch option,
        case 'Yes',
            obj.gui.experiment.last_gui_version = SequenceViewer.version_str;
            saved = obj.experiment.sc_save(false);
            if saved
                obj.has_unsaved_changes = false;
                close_all_windows(obj);
            end
        case 'No, close without saving'
            close_all_windows(obj);
        case 'Cancel'
            return
        otherwise
            error(['debugging error: unknown option: ' option])
    end
else
    close_all_windows(obj);
end
end

function close_all_windows(obj)
delete(obj.btn_window);
% if ~isempty(obj.plot_window_pr) && ishandle(obj.plot_window_pr)
%     close(obj.plot_window_pr);
% end
% if ~isempty(obj.histogram_window_pr) && ishandle(obj.histogram_window_pr)
%     close(obj.histogram_window_pr);   
% end
delete(obj)
end