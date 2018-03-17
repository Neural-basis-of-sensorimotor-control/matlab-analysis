function set_axes_height(val)

if isnumeric(val)
  val = num2str(val);
end

sc_settings.write_settings('axes_height', val);

end