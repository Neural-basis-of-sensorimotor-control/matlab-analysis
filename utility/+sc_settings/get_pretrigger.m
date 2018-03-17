function val = get_pretrigger()

val = sc_settings.read_settings('pretrigger');

if isempty(val)
  val = -1;
else
  val = str2double(val);
end

end