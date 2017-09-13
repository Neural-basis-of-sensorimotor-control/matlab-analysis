function sc_save(obj, varargin)

update_threshold(obj);

obj.signal.sc_save(varargin{:});

obj.has_unsaved_changes = false;

end