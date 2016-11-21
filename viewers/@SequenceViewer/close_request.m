function close_request(obj)

if obj.has_unsaved_changes
	option = questdlg('There are unsaved changes. Save before closing?',...
		'Close Request Function',...
		'Yes','No, close without saving','Cancel','Yes');
  
	if isempty(option)
    option = 'Cancel';  
  end
  
  switch option,
		case 'Yes',
			saved = obj.experiment.save_experiment(obj.abs_save_path, false);
      
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
delete(obj)
end
