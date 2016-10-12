function val = get_intra_experiment_dir()

s = xml2struct('sc.xml');

val = s.sc_settings.intra_experiment_dir.Text;

end