function val = get_mode()

global SC_DEBUG

if ischar(SC_DEBUG)
  val = SC_DEBUG;
else
  val = ~isempty(SC_DEBUG) && SC_DEBUG;
end

end