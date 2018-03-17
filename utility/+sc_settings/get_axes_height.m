function val = get_axes_height()

val = sc_settings.read_settings('axes_height');

if isempty(val)
  val = 'auto';
elseif ischar(val) && ~strcmpi(val, 'auto')
  val = str2num(val);
end

end