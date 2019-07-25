function val = get_raw_data_dir()

val = sc_settings.read_settings(sc_settings.tags.RAW_DATA_DIR);

if ~isempty(val) && val(end) ~= filesep
  val(end+1) = filesep;
end

end
