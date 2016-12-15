function val = isfile(filepath)

val = exist(filepath, 'file') && ~exist(filepath, 'dir');

end