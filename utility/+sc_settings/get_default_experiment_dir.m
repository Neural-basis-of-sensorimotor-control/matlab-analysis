function val = get_default_experiment_dir()

val = sc_settings.read_settings('intra_experiment_dir');

if ~isempty(val) && val(end) ~= filesep
  val(end+1) = filesep;
end

end