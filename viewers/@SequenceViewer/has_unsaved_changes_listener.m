function has_unsaved_changes_listener(obj)
if ~obj.has_unsaved_changes && ~isempty(obj.experiment)
    obj.experiment.last_gui_version = obj.version_str;
end