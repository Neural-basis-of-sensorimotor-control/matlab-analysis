function val = get_raw_data_dir()

filename = 'sc.xml';

try
	s = xml2struct(filename);
catch
	warning('Could not read %s settings file', filename);
	val = [];
	return
end

val = s.sc_settings.raw_data_dir.Text;

if ~isempty(val) && val(end) ~= filesep
  val(end+1) = filesep;
end

end