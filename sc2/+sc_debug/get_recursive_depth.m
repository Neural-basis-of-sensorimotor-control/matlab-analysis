function val = get_recursive_depth()

global SC_RECURSIVE_DEPTH

if ~isempty(SC_RECURSIVE_DEPTH)
  val = SC_RECURSIVE_DEPTH;
else
  val = 2;
end

end