function val = get_debug_mode()

global DEBUG

if ischar(DEBUG)
  val = DEBUG;
else
  val = ~isempty(DEBUG) && DEBUG;
end

end