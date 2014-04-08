function sc_close_request(~,~,guimgr)

if ~isempty(guimgr)
    if guimgr.has_unsaved_changes
        option = questdlg('There are unsaved changes. Save before closing?',...
        'Close Request Function',...
        'Yes','No, close without saving','Cancel','Yes');
        if isempty(option), option = 'Cancel';  end
        switch option,
            case 'Yes',
                saved = guimgr.experiment.sc_save();
                if saved
                    guimgr.has_unsaved_changes = false;
                    delete(guimgr.current_view);
                end
            case 'No, close without saving'
                delete(guimgr.current_view)
            case 'Cancel'
                return
            otherwise
                error(['debugging error: unknown option: ' option])
        end
    else
        delete(guimgr.current_view);
    end
else
    delete(guimgr.current_view);
end

end