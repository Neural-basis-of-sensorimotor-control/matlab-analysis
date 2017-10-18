function val = get_mode()

global SC_PRINT_MODE

if isempty(SC_PRINT_MODE)
  val = false;
else
  val = SC_PRINT_MODE;
end

end