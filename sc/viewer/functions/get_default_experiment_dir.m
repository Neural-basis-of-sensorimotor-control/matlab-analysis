function val = get_default_experiment_dir()

filename = 'sc.xml';

try
	s = xml2struct(filename);
catch
	warning('Could not read %s settings file', filename);
	val = [];
	return
end

val = s.sc_settings.intra_experiment_dir.Text;

if ~isempty(val) && val(end) ~= filesep
  val(end+1) = filesep;
end

end