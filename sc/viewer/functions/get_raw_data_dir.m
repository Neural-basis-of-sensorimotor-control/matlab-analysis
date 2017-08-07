function val = get_raw_data_dir()

val = read_sc_settings('raw_data_dir');

if ~isempty(val) && val(end) ~= filesep
  val(end+1) = filesep;
end

end
