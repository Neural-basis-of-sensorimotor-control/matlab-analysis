function val = get_posttrigger()

val = sc_settings.read_settings('posttrigger');

if isempty(val)
  val = 1;
else
  val = str2double(val);
end

end