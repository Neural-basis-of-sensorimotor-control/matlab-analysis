function val = isfile(filepath)

if exist('isfile', 'builtin')
  % Function exists in Matlab >= 2017b
  val = builtin('isfile', filepath);
else
  val = ~isempty(filepath) && exist(filepath, 'file') && ~exist(filepath, 'dir');
end

end