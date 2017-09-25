function val = isfile(filepath)

val = ~isempty(filepath) && exist(filepath, 'file') && ~exist(filepath, 'dir');

end