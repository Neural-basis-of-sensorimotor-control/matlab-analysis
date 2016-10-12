function val = get_raw_data_dir()

s = xml2struct('sc.xml');

val = s.sc_settings.raw_data_dir.Text;

end