function val = is_file(filepath)

val = ~isempty(filepath) && exist(filepath, 'file') && ~exist(filepath, 'dir');

end