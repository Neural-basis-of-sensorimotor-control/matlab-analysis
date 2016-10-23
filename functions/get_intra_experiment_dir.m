function val = get_intra_experiment_dir()

filename = 'sc.xml';

try
	s = xml2struct(filename);
catch
	warning('Could not read %s settings file', filename);
	val = [];
	return
end

val = s.sc_settings.intra_experiment_dir.Text;

end