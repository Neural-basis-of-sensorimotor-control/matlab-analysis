function set_posttrigger(val)

if isnumeric(val)
  val = num2str(val);
end

sc_settings.write_settings('posttrigger', val);

end