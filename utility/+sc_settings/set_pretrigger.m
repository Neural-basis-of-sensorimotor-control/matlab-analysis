function set_pretrigger(val)

if isnumeric(val)
  val = num2str(val);
end

sc_settings.write_settings('pretrigger', val);

end